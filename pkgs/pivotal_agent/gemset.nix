{
  "daemons" = {
    version = "1.2.3";
    source = {
      type = "gem";
      sha256 = "0b839hryy9sg7x3knsa1d6vfiyvn0mlsnhsb6an8zsalyrz1zgqg";
    };
  };
  "faraday" = {
    version = "0.9.2";
    source = {
      type = "gem";
      sha256 = "1kplqkpn2s2yl3lxdf6h7sfldqvkbkpxwwxhyk7mdhjplb5faqh6";
    };
    dependencies = [
      "multipart-post"
    ];
  };
  "faraday_middleware" = {
    version = "0.10.0";
    source = {
      type = "gem";
      sha256 = "0nxia26xzy8i56qfyz1bg8dg9yb26swpgci8n5jry8mh4bnx5r5h";
    };
    dependencies = [
      "faraday"
    ];
  };
  "json" = {
    version = "1.8.3";
    source = {
      type = "gem";
      sha256 = "1nsby6ry8l9xg3yw4adlhk2pnc7i0h0rznvcss4vk3v74qg0k8lc";
    };
  };
  "multipart-post" = {
    version = "2.0.0";
    source = {
      type = "gem";
      sha256 = "09k0b3cybqilk1gwrwwain95rdypixb2q9w65gd44gfzsd84xi1x";
    };
  };
  "newrelic_plugin" = {
    version = "1.3.1";
    source = {
      type = "gem";
      sha256 = "0vmm82mjb9spbs6sb9b94yk8b58dzhflzvgzpyhv7jb3rfdng7ak";
    };
    dependencies = [
      "json"
    ];
  };
  "rabbitmq_manager" = {
    version = "0.1.0";
    source = {
      type = "gem";
      sha256 = "0364ljnk9y13b7lj0i2mks62g6c9ywv4py4v17p6fzrfx693mmbc";
    };
    dependencies = [
      "faraday"
      "faraday_middleware"
    ];
  };
  "redis" = {
    version = "3.2.1";
    source = {
      type = "gem";
      sha256 = "16jzlqp80qiqg5cdc9l144n6k3c5qj9if4pgij87sscn8ahi993k";
    };
  };
}