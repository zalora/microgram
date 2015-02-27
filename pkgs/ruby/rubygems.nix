# Copyright (c) 2003-2006 Eelco Dolstra
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

args : with args; 

rec {
  name = "rubygems-" + version;
  version = "2.4.1";
  src = fetchurl {
    url = "http://production.cf.rubygems.org/rubygems/${name}.tgz";
    sha256 = "0cpr6cx3h74ykpb0cp4p4xg7a8j0bhz3sk271jq69l4mm4zy4h4f";
  };

  buildInputs = [ruby makeWrapper];
  configureFlags = [];

  doInstall = fullDepEntry (''
    ruby setup.rb --prefix=$out/
    wrapProgram $out/bin/gem --prefix RUBYLIB : $out/lib
    find $out -type f -name "*.rb" | xargs sed -i "s@/usr/bin/env@$(type -p env)@g"
    mkdir -pv $out/nix-support
    cat > $out/nix-support/setup-hook <<EOF
    export RUBYOPT=rubygems
    addToSearchPath RUBYLIB $out/lib
    EOF'') ["minInit" "addInputs" "doUnpack" "defEnsureDir"];

  /* doConfigure should be specified separately */
  phaseNames = ["doPatch" "doInstall"];
      
  meta = {
    description = "Ruby gems package collection";
    longDescription = ''
      Nix can create nix packages from gems.

      To use it by installing gem-nix package.
    '';
  };

  patches = [ ./gem_hook.patch ];
}
