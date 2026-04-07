## My NIXOS config

To bring the system up from scratch, do the following:

##### User password

- create `./nixos/ignored_files/amr_user_password.txt` and put the login password there.
- Note: vim adds new lines, make sure to remove those.
- https://stackoverflow.com/questions/1050640/how-to-stop-vim-from-adding-a-newline-at-end-of-file

##### SSH keys

- sync ssh keys
- create `./home-manager/users/amr/ssh_keys/github` and put the private key there (found in bitwarden).
- create `./home-manager/users/amr/ssh_keys/gitlab_tu_dortmund` and put the private key there (found in bitwarden).

##### GPG keys

- Create the GPG key files.
- `./home-manager/ignored_files/gitos_gpg_private_key` with the armored private key.
- The public key and fingerprint are declared in `./home-manager/gpg.nix`.
- Home Manager imports them into `~/.gnupg` during activation and marks the key as ultimately trusted.

##### Openvpn

- Create `nixos/ignored_files/gitos_openvpn_client_private_key` and put the Gitos VPN private key there.
- The VPN profile reads it from `/etc/nixos/nixos/ignored_files/gitos_openvpn_client_private_key` after the repo is checked out under `/etc/nixos`.

##### Start the system

- `sudo nixos-rebuild switch --flake /etc/nixos#amr`

- `nix-shell -p home-manager`

- `home-manager switch --flake /etc/nixos#amr`

#### Note!!

When using the git repo in the `/etc/nixos` directory, make sure to delete `.git` and `.gitignore`. Otherwise, the nix flake
ignores files needed in the build process like the private keys and the user password added above.
