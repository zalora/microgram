{ buildPythonPackage, fetchgit, stdenv, boto, gcs-oauth2-boto-plugin, sqlite3 }:

buildPythonPackage rec {

  name = "heavy-sync-0.1";

  src = fetchgit {
    url = "https://github.com/zalora/heavy-sync.git";
    rev = "b55f2d458bfeb55324bc0c81e28914ad8d09a64e";
    sha256 = "ce748654f093c5c0033747e09d6230949465b963e155469205c3f1d6a02d33a0";
  };

  propagatedBuildInputs = [
    boto gcs-oauth2-boto-plugin
    sqlite3 # For SQLite 3 support in Python
  ];

  meta = with stdenv.lib; {
    description = "Synchronize huge cloud buckets with ease";
    homepage = "https://github.com/zalora/heavy-sync";
    license = licenses.mpl20;
  };
}
