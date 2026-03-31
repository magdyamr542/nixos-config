## My NIXOS config

To start:

1. create `./nixos/users/amr/password.txt` and put the login password there.
   - Note: vim adds new lines, make sure to remove those
   - https://stackoverflow.com/questions/1050640/how-to-stop-vim-from-adding-a-newline-at-end-of-file
1. sync ssh keys
   - create `./home-manager/users/amr/ssh_keys/github` and put the private key there (found in bitwarden).
   - create `./home-manager/users/amr/ssh_keys/gitlab_tu_dortmund` and put the private key there (found in bitwarden).
1. Create `nixos/vpns/gitos/client.key` and put the Gitos VPN private key there.
   - This file is intentionally gitignored.
   - The VPN profile reads it from `/etc/nixos/nixos/vpns/gitos/client.key` after the repo is checked out under `/etc/nixos`.
1. `sudo nixos-rebuild switch --flake /etc/nixos#amr`
1. `nix-shell -p home-manager`
1. `home-manager switch --flake /etc/nixos#amr`

#### Note!!

When using the git repo in the `/etc/nixos` directory, make sure to delete `.git` and `.gitignore`. Otherwise, the nix flake
ignores files needed in the build process like the private keys and the user password added above.
