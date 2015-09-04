{-# LANGUAGE LambdaCase #-}

module Main (main) where

import Control.Applicative ((<$>), (<*>), pure)
import Control.Exception (bracket)
import Control.Monad (filterM)
import System.Directory (canonicalizePath, doesFileExist, executable, getCurrentDirectory, getDirectoryContents, getPermissions, setCurrentDirectory)
import System.Environment (getEnv)
import System.Exit (exitWith)
import System.FilePath.Posix ((</>), takeBaseName)
import System.IO (hClose)
import System.IO.Temp (withSystemTempFile)
import System.Posix.Signals (Handler(Catch), installHandler, sigHUP, sigTERM, signalProcess, Signal)
import System.Posix.Types (ProcessID)
import System.Process (createProcess, proc, terminateProcess, waitForProcess, ProcessHandle())
import System.Process.Internals (ProcessHandle__(ClosedHandle, OpenHandle), withProcessHandle)


data App = App
    { appExe :: FilePath
    , appName :: String
    }

data Config = Config
    { configAngelFile :: FilePath
    , configAppsRoot :: FilePath
    , configAppRunRelPath :: FilePath
    }

main :: IO ()
main =
    withConfig $ \c -> do
        angelPH <- createAngle c
        _ <- installHandler sigHUP (Catch (reloadAngel c angelPH)) Nothing 
        _ <- installHandler sigTERM (Catch (terminateProcess angelPH)) Nothing
        waitForProcess angelPH >>= exitWith

createAngle :: Config -> IO ProcessHandle
createAngle c = do
    (_, _, _, ph) <- createProcess (proc "angel" [configAngelFile c])
    return ph

reloadAngel :: Config -> ProcessHandle -> IO ()
reloadAngel c ph =
    rebuildConfig c >> signalProcessHandle sigHUP ph

withConfig :: (Config -> IO ()) -> IO ()
withConfig f = do
    appsRoot <- getEnv "APPSROOT"
    appRunRelPath <- getEnv "APPRUNRELPATH"
    withSystemTempFile "applicator.conf" $ \angelConfigFile _handle -> do
        hClose _handle
        let c = Config angelConfigFile appsRoot appRunRelPath
        rebuildConfig c
        f c

rebuildConfig :: Config -> IO ()
rebuildConfig c =
    getApps c >>= writeFile (configAngelFile c) . concatMap formatAngelEntry

formatAngelEntry :: App -> String
formatAngelEntry a =
    concat
        [ appName a ++ " {\n"
        , "  exec = " ++ show (appExe a) ++ "\n"
        , "}\n"
        ]

getApps :: Config -> IO [App]
getApps c =
    withCurrentDirectory (configAppsRoot c) $
        getDirectoryContents "." >>=
        return . filter (\p -> p /= "." && p /= "..") >>=
        filterM (executableExists . getAppExe c) >>=
        mapM (\p ->
            App <$> canonicalizePath (getAppExe c p)
                <*> pure (getAppName p))

getAppExe :: Config -> FilePath -> FilePath
getAppExe c p =
    p </> configAppRunRelPath c

getAppName :: FilePath -> String
getAppName =
    takeBaseName

executableExists :: FilePath -> IO Bool
executableExists p = do
    exists <- doesFileExist p
    if exists
        then executable <$> getPermissions p
        else return False

getProcessID :: ProcessHandle -> IO (Maybe ProcessID)
getProcessID ph =
    withProcessHandle ph $ \case
        OpenHandle x   -> return $ Just x
        ClosedHandle _ -> return Nothing

signalProcessHandle :: Signal -> ProcessHandle -> IO ()
signalProcessHandle sig ph =
    getProcessID ph >>= \case
        Just pid -> signalProcess sig pid
        Nothing -> putStrLn "signalProcessHandle: process is already dead."

-- Since: directory-1.2.3.0
withCurrentDirectory :: FilePath -> IO a -> IO a
withCurrentDirectory dir action =
    bracket getCurrentDirectory setCurrentDirectory $ \ _ -> do
        setCurrentDirectory dir
        action
