## My NIXOS config

To start:

1. create `./nixos/users/amr/password.txt` and put the login password there.
   - Note: vim adds new lines, make sure to remove those
   - https://stackoverflow.com/questions/1050640/how-to-stop-vim-from-adding-a-newline-at-end-of-file
2. create `./home-manager/users/amr/ssh_keys/github` and put the github private key there (found in bitwarden).
3. `sudo nixos-rebuild switch --flake /etc/nixos#amr`
4. `nix-shell -p home-manager`
5. `home-manager switch --flake /etc/nixos#amr`

#### Note!!

When using the git repo in the `/etc/nixos` directory, make sure to delete `.git` and `.gitignore`. Otherwise, the nix flake
ignores files needed in the build process like the private keys and the user password added above.
