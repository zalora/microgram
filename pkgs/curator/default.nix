{ buildPythonPackage, fetchgit, stdenv, click, elasticsearch, urllib3, ... }:

buildPythonPackage {
  name = "curator";

  src = fetchgit {
    url = "https://github.com/elastic/curator.git";
    rev = "f4fb814fd4ffb227dd20b3010940575f00c509f1";
    sha256 = "1p6qmfk9j9ng8rgkz8q3mc7f9mc96xhn585g14f8zqy65wflz3q1";
  };

  # Test suite tries to make requests against a local elasticsearch, would
  # rather not supply this in the build environment. Revisit later?
  doCheck = false;

  propagatedBuildInputs = [click elasticsearch urllib3];
}
