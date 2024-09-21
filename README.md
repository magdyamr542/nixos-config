## My NIXOS config

To start, create `./nixos/users/amr/password.txt` and put the login password there.
Then do `nixos-rebuild switch --flake /etc/nixos#amr` followed by `home-manager switch --flake /etc/nixos#amr`
The OS should be ready to use after that.
