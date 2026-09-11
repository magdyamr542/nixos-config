{ host, ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        name = host.fullName;
        email = host.email;
      };
      column.ui = "auto";
      init.defaultBranch = "main";
      merge.conflictStyle = "diff3";
      diff.colorMoved = "default";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      dark = true;
      features = "decorations";
      line-numbers = true;
      paging = "always";
      side-by-side = false;

      decorations = {
        commit-style = "raw";
        file-style = "omit";
        hunk-header-decoration-style = "blue box";
        hunk-header-file-style = "red";
        hunk-header-line-number-style = "#067a00";
        hunk-header-style = "file line-number syntax";
      };
    };
  };
}
