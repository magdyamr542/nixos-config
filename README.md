## My NIXOS config

To start:

1. create `./nixos/users/amr/password.txt` and put the login password there.
2. create `./home-manager/users/amr/ssh_keys/github` and put the github private key there (found in bitwarden).
3. `nixos-rebuild switch --flake /etc/nixos#amr`
4. `home-manager switch --flake /etc/nixos#amr`
