{ buildPythonPackage, fetchgit, stdenv, boto, gcs-oauth2-boto-plugin, sqlite3 }:

buildPythonPackage rec {

  name = "heavy-sync-0.1";

  src = fetchgit {
    url = "https://github.com/zalora/heavy-sync.git";
    rev = "27186e17bdbca911492041316a1a11ab5335b57b";
    sha256 = "6b269c2ad01f55dccb4915cdac95631093b5e2e82b0e9d71f5a7c53756cf0484";
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
