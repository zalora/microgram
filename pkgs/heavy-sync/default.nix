{ buildPythonPackage, fetchgit, stdenv, boto, gcs-oauth2-boto-plugin, sqlite3 }:

buildPythonPackage rec {

  name = "heavy-sync-0.1";

  src = fetchgit {
    url = "https://github.com/zalora/heavy-sync.git";
    rev = "d45897d01f81cde83a92a5203258ef6715a3ce4e";
    sha256 = "31d40538f3fd71d608597850599c5f71138a48d0598c48aa5ecfd3a1b1844ae6";
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
