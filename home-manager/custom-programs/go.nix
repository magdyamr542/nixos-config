{  
  lib,
  pkgs,
  buildGoModule,
  fetchFromGitHub,
  ...
}:
{
  ssh-tunnel-manager = buildGoModule rec {
    pname = "ssh-tunnel-manager";
    version = "1.0.0";

    src = fetchFromGitHub {
      owner = "magdyamr542";
      repo = "ssh-tunnel-manager";
      rev = "a555cb37eafcfa2e838dbd0b2d37cd4e8951ebbf";
      hash = "sha256-jN+5m2zqVNjk96JmKynBRSo0hvjmE5OE+QglR+Vkon4=";
    };

	  vendorHash = "sha256-9x+YDgUd0jdcMAbKr9HA3fATAh3qkvbQgIMVtIkK850=";

    meta = {
      description = "My go command managing ssh tunnels";
      homepage = "https://github.com/magdyamr542/ssh-tunnel-manager";
    };
  };


  browser-tab-groups = buildGoModule rec {
    pname = "browser-tab-groups";
    version = "1.0.0";

    src = fetchFromGitHub {
      owner = "magdyamr542";
      repo = "browser-tab-groups";
      rev = "59a357e80afbb0a72069e40985a90a4635a5cc84";
      hash = "sha256-9i7Dd+f7rtb9XidCzINU64ct7vS/7KTewJvF8kRDPLk=";
    };

	  vendorHash = "sha256-injNtarzeblUpQ/mq8VosQJuYU+9w65ttvdkgCKLGYA=";

    meta = {
      description = "My go command managing tab groups";
      homepage = "https://github.com/magdyamr542/browser-tab-groups";
    };
  };



  project-root = buildGoModule rec {
    pname = "project-root";
    version = "1.0.0";

    src = fetchFromGitHub {
      owner = "magdyamr542";
      repo = "project-root";
      rev = "a79b29aa8b750eee560074b20088eefc60d04647";
      hash = "sha256-eFgDKIfNnYcZKbyQarw/Tp2gs/cMddtHVBMxZYiXbZg=";
    };

	  vendorHash = "sha256-i59HUK9KRw06Rk50WPN0WKllpAd9T5uASKN7jjSTxdU=";

    meta = {
      description = "My go command managing tab groups";
      homepage = "https://github.com/magdyamr542/project-root";
    };
  };

}