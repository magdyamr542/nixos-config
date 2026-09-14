{
  pkgs ?
    import
      (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/ad37ffa4485bd9d85ef09beb0cbc7c9b09459a98.tar.gz";
      })
      {
        config.allowUnfree = true;
      },
}:

let
  claude =
    if builtins.hasAttr "claude-code" pkgs then
      pkgs."claude-code"
    else if builtins.hasAttr "claude-code-bin" pkgs then
      pkgs."claude-code-bin"
    else
      throw ''
        Neither "claude-code" nor "claude-code-bin" exists in the selected nixpkgs commit.
      '';

  codex = pkgs.codex;
in
pkgs.mkShell {
  packages = [
    claude
    codex
    pkgs.vagrant
  ];

  shellHook = ''
    if ! vagrant plugin list 2>/dev/null | grep -q '^vagrant-disksize'; then
      echo "Installing vagrant-disksize plugin..."
      vagrant plugin install vagrant-disksize
    fi
  '';
}
