module Main (main) where

import Prelude ((.),(=<<),IO)
import Data.Aeson.Encode (encode)
import System.Environment (getArgs)
import Data.ByteString.Lazy.Char8 (putStrLn)

main :: IO ()
main = putStrLn . encode =<< getArgs
