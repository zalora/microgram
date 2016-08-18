{ buildPythonPackage, fetchFromGitHub, stdenv, boto, gcs-oauth2-boto-plugin, sqlite3 }:

buildPythonPackage rec {

  name = "heavy-sync-0.1";

  src = fetchFromGitHub {
    owner = "zalora";
    repo = "heavy-sync";
    rev = "c41e0b7244941108c4cf655ff4c981654ccdfa21";
    sha256 = "0ngp2bmjhgzzdbx65wx3c7g8z0iasdfy44wwbb7s2c1m4rhnwzb6";
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
