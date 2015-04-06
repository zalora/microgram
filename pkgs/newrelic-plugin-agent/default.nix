{ buildPythonPackage, fetchurl, stdenv, helper, requests2 }:

buildPythonPackage rec {
  name = "newrelic-plugin-agent-1.3.0";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/n/newrelic_plugin_agent/newrelic_plugin_agent-1.3.0.tar.gz";
    md5 = "8855e9802cd0476d862ebb12ed22bd32";
  };

  # The package tries to install some example config files to /opt
  preInstall = ''
    sed -i '/data_files=/d' setup.py
  '';

  propagatedBuildInputs = [
    helper
    requests2
  ];

  meta = with stdenv.lib; {
    description = "Python based agent for collecting metrics for NewRelic";
    homepage = https://github.com/MeetMe/newrelic-plugin-agent;
  };
}
