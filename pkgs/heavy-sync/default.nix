{ buildPythonPackage, fetchgit, stdenv, boto, gcs-oauth2-boto-plugin, sqlite3 }:

buildPythonPackage rec {

  name = "heavy-sync-0.1";

  src = fetchgit {
    url = "https://github.com/zalora/heavy-sync.git";
    rev = "22cf81fc45108e9a4ed8676393b53f20d9f4e73f";
    sha256 = "565320cee776366b4daa2cb83b68c3550c816f85c0f724c793623aae42403143";
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
