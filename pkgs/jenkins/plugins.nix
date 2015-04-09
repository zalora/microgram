{
  "antisamy-markup-formatter" = {
    version = "1.3";
    sha1 = "b94e906e1f13b1333063cf620ae670bad3542240";
    depends = [  ];
  };
  "console-column-plugin" = {
    version = "1.5";
    sha1 = "9ad77fe5c4cd3301435e30cb4a5dc6791770c996";
    depends = [  ];
  };
  "console-tail" = {
    version = "1.1";
    sha1 = "dd875be276508de3c3284c52b5ab1416df97c186";
    depends = [  ];
  };
  "copyartifact" = {
    version = "1.35";
    sha1 = "a39c54502ff9441144ae45da03bffbc36d20bfca";
    depends = [ "matrix-project" ];
  };
  "credentials" = {
    version = "1.22";
    sha1 = "15fe1d3947a7c64b67f653ba0aa48413fdb7304e";
    depends = [  ];
  };
  "dashboard-view" = {
    version = "2.9.4";
    sha1 = "798487d96cffeda0da051ee632666b7148c6ae10";
    depends = [  ];
  };
  "environment-dashboard" = {
    version = "1.1.3";
    sha1 = "5155c745d0777edc1d15ddc76f12cf25268d5dda";
    depends = [ "jquery" ];
  };
  "external-monitor-job" = {
    version = "1.4";
    sha1 = "6969401bf7f766e38f1a6a2754201bd32ecfed01";
    depends = [  ];
  };
  "extra-columns" = {
    version = "1.15";
    sha1 = "69f30cfdf9d0f11684e5e8ce7f0d94fbe170fca6";
    depends = [  ];
  };
  "ghprb" = {
    version = "1.17";
    sha1 = "19a47b00dbed846d158d0812e1b78f1960269cb0";
    depends = [ "github-api" "git" "ssh-agent" "token-macro" ];
  };
  "git" = {
    version = "2.3.5";
    sha1 = "3541220f71425fc8345c41453f775a6c10077d40";
    depends = [ "git-client" "credentials" "ssh-credentials" "scm-api" "matrix-project" "mailer" "token-macro" "promoted-builds" ];
  };
  "git-client" = {
    version = "1.16.1";
    sha1 = "df981521f905d0c3d2442945cf93444cf1ec02d3";
    depends = [ "ssh-credentials" ];
  };
  "git-parameter" = {
    version = "0.4.0";
    sha1 = "b6f7bbfa5652ce0980f5d6dd0346a24e7de33598";
    depends = [ "credentials" "git" ];
  };
  "github" = {
    version = "1.11.2";
    sha1 = "eccb6ccf4c73ded3552d2e92c5743680bd06a1fb";
    depends = [ "github-api" "git" "multiple-scms" ];
  };
  "github-api" = {
    version = "1.66";
    sha1 = "ecea4baa691cc90ded35685d8681e6701c9e3d8d";
    depends = [  ];
  };
  "github-oauth" = {
    version = "0.20";
    sha1 = "c83a0e495fa2a6dcac3878091f4e9eab5d392ec5";
    depends = [ "mailer" "github-api" "git" ];
  };
  "google-login" = {
    version = "1.1";
    sha1 = "4dd48ba7dc53b1b8fff55b377f4ede04ff0c9ceb";
    depends = [ "mailer" ];
  };
  "google-oauth-plugin" = {
    version = "0.3";
    sha1 = "3bfef4715cff97cf2ade9b903fed9f76ebd3f99a";
    depends = [ "oauth-credentials" ];
  };
  "jenkinswalldisplay" = {
    version = "0.6.30";
    sha1 = "bf5a7e4c00beb7371335517dcb91a3f71e6ffd27";
    depends = [ "nested-view" ];
  };
  "jquery" = {
    version = "1.7.2-1";
    sha1 = "521aa3c192bd6242f3bc7a06664616000f1cb212";
    depends = [  ];
  };
  "log-command" = {
    version = "1.0.1";
    sha1 = "e3ade31612cc5bb24cd29e2578570074e9f1f203";
    depends = [  ];
  };
  "mailer" = {
    version = "1.15";
    sha1 = "72a4aa4e53d29e894e512c38a00bfbae1ab3a9f4";
    depends = [  ];
  };
  "mapdb-api" = {
    version = "1.0.6.0";
    sha1 = "fe1bea979b187ed051d56e6042370f8c2359c74a";
    depends = [  ];
  };
  "matrix-auth" = {
    version = "1.2";
    sha1 = "91a7ebbee0c81b6fa5a954b182f11e7e4ba4a5d1";
    depends = [  ];
  };
  "matrix-project" = {
    version = "1.4";
    sha1 = "bf14b558cf731e6078dd9d226fe197f13d3d6924";
    depends = [  ];
  };
  "multiple-scms" = {
    version = "0.4";
    sha1 = "e235b33ea49aee968c69720c9d65ff1d668292c8";
    depends = [  ];
  };
  "nested-view" = {
    version = "1.14";
    sha1 = "6d3e852353e2ab7e45e32fe2a86ea5c3acec9b1b";
    depends = [  ];
  };
  "oauth-credentials" = {
    version = "0.3";
    sha1 = "4c355b5b36445ef15754c3e9ea1e885c9acad7ee";
    depends = [  ];
  };
  "promoted-builds" = {
    version = "2.21";
    sha1 = "b1af89881bd2ccb0269190fbef8b3fdedad93558";
    depends = [  ];
  };
  "rebuild" = {
    version = "1.22";
    sha1 = "09d213f5d88228812d29cd0f3bbff83fbcf761d0";
    depends = [  ];
  };
  "s3" = {
    version = "0.7";
    sha1 = "01ddd81e5dba67785351da32564d8a29eacb001d";
    depends = [ "copyartifact" ];
  };
  "scm-api" = {
    version = "0.2";
    sha1 = "cc98487e2daaf7484a2028f62828bf6f9ef986ce";
    depends = [  ];
  };
  "script-security" = {
    version = "1.13";
    sha1 = "70599560a5c090b96c11f34ebe4268cac1e5eb64";
    depends = [  ];
  };
  "show-build-parameters" = {
    version = "1.0";
    sha1 = "69ee5b0307cc907ce80c182cc80035c88311b9c0";
    depends = [  ];
  };
  "simple-theme-plugin" = {
    version = "0.3";
    sha1 = "ffec39d93f62916fe6aadbab75544d443c4efe5e";
    depends = [  ];
  };
  "slack" = {
    version = "1.7";
    sha1 = "7d354aef726e1e462b0f625b478ae47ce823c25c";
    depends = [  ];
  };
  "ssh-agent" = {
    version = "1.5";
    sha1 = "f68e44ad33f52399c113b8006dbe7073e5c28526";
    depends = [ "credentials" "ssh-credentials" ];
  };
  "ssh-credentials" = {
    version = "1.11";
    sha1 = "d47e6a2899ee75e48336f6d2637da4e9ba0e3d21";
    depends = [ "credentials" ];
  };
  "ssh-slaves" = {
    version = "1.9";
    sha1 = "ca2be1b3ca6d674b219cd0ead7e8637655d3cf04";
    depends = [ "credentials" "ssh-credentials" ];
  };
  "timestamper" = {
    version = "1.6";
    sha1 = "a2170b6e1a9a36d1c85ba700890d6d54e5619b60";
    depends = [  ];
  };
  "token-macro" = {
    version = "1.10";
    sha1 = "ff86c407c184cce1eaa35f499fc16a7a724a96e2";
    depends = [  ];
  };
}
