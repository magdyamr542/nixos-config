{
  host,
  lib,
  ...
}:

{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = [
      (
        {
          alias.crb = "rev-parse --abbrev-ref HEAD";
          column.ui = "auto";
          core.pager = "delta";
          diff.colorMoved = "default";
          init.defaultBranch = "main";
          interactive.diffFilter = "delta --color-only --features=interactive";
          merge.conflictStyle = "diff3";
          pull.rebase = false;
          url."git@github.com:enercity".insteadOf = "https://github.com/enercity";
        }
        // lib.optionalAttrs (host.fullName != "" || host.email != "") {
          user =
            lib.optionalAttrs (host.fullName != "") {
              name = host.fullName;
            }
            // lib.optionalAttrs (host.email != "") {
              email = host.email;
            };
        }
      )
    ];
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
