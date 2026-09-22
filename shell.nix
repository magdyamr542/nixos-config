{
  pkgs ?
    import
      (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/ece1ef61e70aeb885f17a1609e09739907453bab.tar.gz";
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
    pkgs.age
    pkgs.sops
  ];

  shellHook = ''
    if ! vagrant plugin list 2>/dev/null | grep -q '^vagrant-disksize'; then
      echo "Installing vagrant-disksize plugin..."
      vagrant plugin install vagrant-disksize
    fi
  '';
}
