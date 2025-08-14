{ pkgs, lib, ... }:
let
  extensions = (import ./extensions.nix) {
    pkgs = pkgs;
    lib = lib;
  };
in
{
  programs.vscode = {
    enable = true;
    profiles.default = {
      enableExtensionUpdateCheck = true;
      enableUpdateCheck = true;
      extensions =
        [
          pkgs.vscode-extensions.vscodevim.vim
          pkgs.vscode-extensions.golang.go
          pkgs.vscode-extensions.ms-python.vscode-pylance
          pkgs.vscode-extensions.esbenp.prettier-vscode
          pkgs.vscode-extensions.dbaeumer.vscode-eslint
          pkgs.vscode-extensions.hashicorp.terraform
          pkgs.vscode-extensions.hashicorp.hcl
          pkgs.vscode-extensions.ms-python.python
          pkgs.vscode-extensions.ms-azuretools.vscode-docker
          pkgs.vscode-extensions.ms-vscode.cmake-tools
          pkgs.vscode-extensions.eamodio.gitlens
          pkgs.vscode-extensions.twxs.cmake
          pkgs.vscode-extensions.pkief.material-icon-theme
          pkgs.vscode-extensions.github.vscode-pull-request-github
          pkgs.vscode-extensions.ms-python.isort
          pkgs.vscode-extensions.ms-vscode-remote.remote-ssh
          pkgs.vscode-extensions.ecmel.vscode-html-css
          pkgs.vscode-extensions.formulahendry.auto-rename-tag
          pkgs.vscode-extensions.vscode-icons-team.vscode-icons
          pkgs.vscode-extensions.christian-kohler.path-intellisense
          pkgs.vscode-extensions.formulahendry.auto-close-tag
          pkgs.vscode-extensions.donjayamanne.githistory
          pkgs.vscode-extensions.streetsidesoftware.code-spell-checker
          pkgs.vscode-extensions.njpwerner.autodocstring
          pkgs.vscode-extensions.editorconfig.editorconfig
          pkgs.vscode-extensions.yzhang.markdown-all-in-one
          pkgs.vscode-extensions.mechatroner.rainbow-csv
          pkgs.vscode-extensions.aaron-bond.better-comments
          pkgs.vscode-extensions.naumovs.color-highlight
          pkgs.vscode-extensions.mikestead.dotenv
          pkgs.vscode-extensions.shd101wyy.markdown-preview-enhanced
          pkgs.vscode-extensions.humao.rest-client
          pkgs.vscode-extensions.alefragnani.bookmarks
          pkgs.vscode-extensions.hbenl.vscode-test-explorer
          pkgs.vscode-extensions.ms-python.black-formatter
          pkgs.vscode-extensions.james-yu.latex-workshop
          pkgs.vscode-extensions.johnpapa.vscode-peacock
          pkgs.vscode-extensions.vincaslt.highlight-matching-tag
          pkgs.vscode-extensions.adpyke.codesnap
          pkgs.vscode-extensions.foxundermoon.shell-format
          pkgs.vscode-extensions.irongeek.vscode-env
          pkgs.vscode-extensions.stkb.rewrap
          pkgs.vscode-extensions.bbenoist.nix
          pkgs.vscode-extensions.zxh404.vscode-proto3
          pkgs.vscode-extensions.rust-lang.rust-analyzer
          pkgs.vscode-extensions.bbenoist.nix
        ]
        ++ [
          extensions.ms-vscode.remote-explorer
          extensions.cschlosser.doxdocgen
          extensions.kevinrose.vsc-python-indent
          extensions.donjayamanne.python-extension-pack
          extensions.wayou.vscode-todo-highlight
          extensions.formulahendry.auto-complete-tag
          extensions.mohsen1.prettify-json
          extensions.tamasfe.even-better-toml
          extensions.pflannery.vscode-versionlens
          extensions.inferrinizzard.prettier-sql-vscode
          extensions.janisdd.vscode-edit-csv
          extensions.nhoizey.gremlins
          extensions.searking.preview-vscode
          extensions.meganrogge.template-string-converter
          extensions.bbenoist.vagrant
          extensions.bruno-api-client.bruno
          extensions.amrmetwally.vim-find-highlight
          extensions.amrmetwally.rust-mod-opener
          extensions.amrmetwally.add-arround
          extensions.yy0931.go-to-next-error
        ];

      keybindings = [
        {
          key = "ctrl+right";
          command = "cursorWordEndRight";
          when = "textInputFocus";
        }
        {
          key = "alt+right";
          command = "-cursorWordEndRight";
          when = "textInputFocus";
        }
        {
          key = "ctrl+left";
          command = "cursorWordEndLeft";
        }
        {
          key = "ctrl+shift+alt+left";
          command = "-cursorWordPartLeftSelect";
          when = "textInputFocus";
        }
        {
          key = "ctrl+shift+alt+right";
          command = "-cursorWordPartRightSelect";
          when = "textInputFocus";
        }
        {
          key = "escape";
          command = "removeSecondaryCursors";
          when = "editorHasMultipleSelections && textInputFocus";
        }
        {
          key = "ctrl+t";
          command = "workbench.action.terminal.focus";
        }
        {
          key = "ctrl+t";
          command = "workbench.action.focusActiveEditorGroup";
          when = "terminalFocus";
        }
        {
          key = "ctrl+`";
          command = "-workbench.action.terminal.toggleTerminal";
        }
        {
          key = "shift+alt+right";
          command = "-cursorWordEndRightSelect";
          when = "textInputFocus";
        }
        {
          key = "shift+cmd+left";
          command = "-cursorHomeSelect";
          when = "textInputFocus";
        }
        {
          key = "shift+alt+right";
          command = "cursorWordRightSelect";
        }
        {
          key = "alt+right";
          command = "cursorWordRight";
        }
        {
          key = "ctrl+space";
          command = "editor.action.triggerSuggest";
          when = "editorHasCompletionItemProvider && textInputFocus && !editorReadonly";
        }
        {
          key = "ctrl+space";
          command = "-editor.action.triggerSuggest";
          when = "editorHasCompletionItemProvider && textInputFocus && !editorReadonly";
        }
        {
          key = "alt+escape";
          command = "-editor.action.triggerSuggest";
          when = "editorHasCompletionItemProvider && textInputFocus && !editorReadonly";
        }
        {
          key = "tab";
          command = "-extension.vim_tab";
          when = "editorFocus && vim.active && !inDebugRepl && vim.mode != 'Insert'";
        }
        {
          key = "ctrl+shift+t";
          command = "workbench.action.terminal.new";
        }
        {
          key = "ctrl+h";
          command = "workbench.action.navigateLeft";
          when = "editorFocus";
        }
        {
          key = "ctrl+l";
          command = "workbench.action.navigateRight";
          when = "editorFocus";
        }
        {
          key = "ctrl+[Backslash]";
          command = "workbench.action.terminal.split";
        }
        {
          key = "ctrl+shift+r";
          command = "editor.action.rename";
          when = "editorHasRenameProvider && editorTextFocus && !editorReadonly";
        }
        {
          key = "f2";
          command = "-editor.action.rename";
          when = "editorHasRenameProvider && editorTextFocus && !editorReadonly";
        }
        {
          key = "ctrl+shift+i";
          command = "editor.action.sourceAction";
          args = {
            kind = "source.addMissingImports";
            apply = "first";
          };
        }
        {
          key = "ctrl+shift+o";
          command = "editor.action.organizeImports";
          when = "editorTextFocus && !editorReadonly && supportedCodeAction =~ /(\\s|^)source\\.organizeImports\\b/";
        }
        {
          key = "shift+alt+o";
          command = "-editor.action.organizeImports";
          when = "editorTextFocus && !editorReadonly && supportedCodeAction =~ /(\\s|^)source\\.organizeImports\\b/";
        }
        {
          key = "tab";
          command = "selectNextQuickFix";
          when = "editorFocus && quickFixWidgetVisible";
        }
        {
          key = "shift+tab";
          command = "selectPrevQuickFix";
          when = "editorFocus && quickFixWidgetVisible";
        }
        {
          key = "tab";
          command = "selectNextSuggestion";
          when = "editorTextFocus && suggestWidgetMultipleSuggestions && suggestWidgetVisible";
        }
        {
          key = "shift+tab";
          command = "selectPrevSuggestion";
          when = "editorTextFocus && suggestWidgetMultipleSuggestions && suggestWidgetVisible";
        }
        {
          key = "ctrl+shift+b";
          command = "workbench.action.toggleSidebarVisibility";
          when = "viewContainer.workbench.view.explorer.enabled";
        }
        {
          key = "ctrl+shift+e";
          command = "workbench.action.explorer";
          when = "viewContainer.workbench.view.explorer.disabled";
        }
        {
          key = "ctrl+k ctrl+w";
          command = "workbench.action.closeOtherEditors";
        }
        {
          key = "ctrl+.";
          command = "-editor.changeDropType";
          when = "dropWidgetVisible";
        }
        {
          key = "ctrl+.";
          command = "-editor.changePasteType";
          when = "pasteWidgetVisible";
        }
      ];

      userSettings = {
        "terminal.integrated.fontFamily" = "monospace";
        "editor.rulers" = [ 120 ];
        "workbench.editor.enablePreview" = false;
        "debug.allowBreakpointsEverywhere" = true;
        "editor.suggestSelection" = "first";
        "terminal.integrated.defaultProfile.osx" = "zsh";
        "terminal.integrated.profiles.osx" = {
          bash = {
            path = "bash";
            args = [ "-l" ];
            icon = "terminal-bash";
          };
          zsh = {
            path = "zsh";
            args = [ "-l" ];
          };
          fish = {
            path = "fish";
            args = [ "-l" ];
          };
          tmux = {
            path = "tmux";
            icon = "terminal-tmux";
          };
          pwsh = {
            path = "pwsh";
            icon = "terminal-powershell";
          };
        };
        "vimFindHighlight.charPrimaryColor" = "green";
        "vimFindHighlight.charSecondaryColor" = "red";
        "vimFindHighlight.charFontWeight" = "800";
        "vimFindHighlight.enableUnderline" = false;
        "vimFindHighlight.enableAutoHighlight" = true;
        "terminal.integrated.allowChords" = false;
        "terminal.integrated.drawBoldTextInBrightColors" = false;
        "workbench.iconTheme" = "material-icon-theme";
        "typescript.preferences.importModuleSpecifier" = "relative";
        "files.exclude" = {
          "**/.classpath" = true;
          "**/.factorypath" = true;
          "**/.project" = true;
          "**/.settings" = true;
          "**/*.class" = true;
        };
        "vim.leader" = "<Space>";
        "vim.visualModeKeyBindingsNonRecursive" = [
          {
            before = [ "p" ];
            after = [
              "p"
              "g"
              "v"
              "y"
            ];
          }
          {
            before = [ "$" ];
            after = [
              "g"
              "_"
            ];
          }
          {
            before = [ "T" ];
            commands = [ "add-arround.insertTemplate" ];
          }
          {
            before = [ "<C-d>" ];
            commands = [ "editor.action.addSelectionToNextFindMatch" ];
          }
        ];
        "vim.insertModeKeyBindings" = [
          {
            before = [
              "j"
              "j"
            ];
            after = [ "<Esc>" ];
          }
        ];
        "vim.normalModeKeyBindings" = [
          {
            before = [
              "m"
              "t"
            ];
            commands = [ { command = "editor.emmet.action.matchTag"; } ];
          }
          {
            before = [ "<C-a>" ];
            after = [
              "g"
              "g"
              "V"
              "G"
            ];
          }
          {
            before = [ "S" ];
            after = [
              ":"
              "s"
              "/"
            ];
          }
          {
            before = [
              "<leader>"
              "b"
            ];
            commands = [ "bookmarks.toggleLabeled" ];
          }
          {
            before = [
              "<leader>"
              "l"
            ];
            commands = [ "bookmarks.listFromAllFiles" ];
          }
          {
            before = [ "<C-n>" ];
            commands = [ ":nohl" ];
          }
          {
            before = [
              "f"
              "d"
            ];
            after = [
              "g"
              "d"
            ];
          }
          {
            before = [ "Y" ];
            after = [
              "y"
              "$"
            ];
          }
          {
            before = [ "$" ];
            after = [
              "g"
              "_"
            ];
          }
          {
            before = [ "T" ];
            commands = [ "add-arround.insertTemplate" ];
          }
        ];
        "vim.normalModeKeyBindingsNonRecursive" = [
          {
            before = [ "<Esc>" ];
            commands = [ ":nohl" ];
          }
          {
            before = [ "=" ];
            after = [ "" ];
            commands = [
              {
                command = "editor.action.reindentlines";
                args = [ ];
              }
            ];
          }
          {
            before = [
              "<leader>"
              "n"
            ];
            commands = [ "go-to-next-error.nextInFiles.warning" ];
          }
          {
            before = [
              "<leader>"
              "i"
            ];
            commands = [ "editor.action.inlineSuggest.trigger" ];
          }
          {
            before = [
              "<leader>"
              "tab"
            ];
            commands = [ "editor.action.inlineSuggest.commit" ];
          }
          {
            before = [
              "<leader>"
              "f"
            ];
            commands = [ "search.action.focusNextSearchResult" ];
          }
          {
            before = [
              "<leader>"
              "g"
              "d"
            ];
            commands = [ "editor.action.goToImplementation" ];
          }
          {
            before = [ "u" ];
            commands = [ "undo" ];
          }
          {
            before = [ "c-r" ];
            commands = [ "redo" ];
          }
        ];
        "vim.easymotion" = true;
        "vim.incsearch" = true;
        "vim.useSystemClipboard" = true;
        "vim.useCtrlKeys" = true;
        "vim.hlsearch" = true;
        "vim.handleKeys" = {
          "<D-c>" = false;
          "<C-f>" = false;
          "<C-p>" = false;
          "<C-w>" = false;
          "<C-k>" = false;
          "<C-e>" = false;
        };
        "search.exclude" = {
          "**/node_modules" = true;
          "**/bower_components" = true;
          "**/*.code-search" = true;
          "**/bot" = true;
        };
        "explorer.confirmDelete" = false;
        "editor.lineNumbers" = "relative";
        "editor.bracketPairColorization.enabled" = false;
        "[proto3]" = {
          "editor.defaultFormatter" = "zxh404.vscode-proto3";
        };
        "[html]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[typescript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[go]" = {
          "editor.defaultFormatter" = "golang.go";
        };
        "[toml]" = {
          "editor.defaultFormatter" = "tamasfe.even-better-toml";
        };
        "[latex]" = {
          "editor.defaultFormatter" = "James-Yu.latex-workshop";
        };
        "latex-workshop.formatting.latex" = "latexindent";
        "editor.formatOnSave" = true;
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[json]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "git.ignoreMissingGitWarning" = true;
        "editor.tabSize" = 4;
        "editor.detectIndentation" = true;
        "editor.insertSpaces" = false;
        "typescript.updateImportsOnFileMove.enabled" = "always";
        "files.associations" = {
          "*.html" = "html";
        };
        "diffEditor.ignoreTrimWhitespace" = false;
        "workbench.editorAssociations" = {
          "*.ipynb" = "jupyter-notebook";
        };
        "[shellscript]" = {
          "editor.defaultFormatter" = "foxundermoon.shell-format";
        };
        "[dockerfile]" = {
          "editor.defaultFormatter" = "ms-azuretools.vscode-docker";
        };
        "editor.cursorStyle" = "line";
        "editor.wordSeparators" = "/\\()\"':,.;<>~!@#$%^&*|+=[]{}`?-";
        "vsicons.dontShowNewVersionMessage" = true;
        "terminal.integrated.defaultProfile.linux" = "zsh";
        "npm.keybindingsChangedWarningShown" = true;
        "editor.stickyScroll.enabled" = true;
        "go.toolsManagement.autoUpdate" = true;
        "auto-close-tag.activationOnLanguage" = [ "HTML (Eex)" ];
        "jupyter.askForKernelRestart" = false;
        "redhat.telemetry.enabled" = false;
        "terminal.integrated.enableMultiLinePasteWarning" = "never";
        "git.openRepositoryInParentFolders" = "never";
        "[python]" = {
          "editor.formatOnType" = true;
          "editor.defaultFormatter" = "ms-python.black-formatter";
          "editor.insertSpaces" = true;
          "editor.tabSize" = 4;
        };
        "[cpp]" = {
          "editor.defaultFormatter" = "ms-vscode.cpptools";
        };
        "[terraform]" = {
          "editor.defaultFormatter" = "hashicorp.terraform";
        };
        "[ignore]" = {
          "editor.defaultFormatter" = "foxundermoon.shell-format";
        };
        "[dotenv]" = {
          "editor.defaultFormatter" = "foxundermoon.shell-format";
        };
        "editor.fontSize" = 14;
        "editor.fontFamily" = "'Droid Sans Mono', 'monospace', monospace";
        "files.watcherExclude" = {
          "**/.bloop" = true;
          "**/.metals" = true;
          "**/.ammonite" = true;
        };
        "workbench.colorTheme" = "Visual Studio Light";
        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
        };
        "[rust]" = {
          "editor.defaultFormatter" = "rust-lang.rust-analyzer";
          "editor.inlayHints.enabled" = "offUnlessPressed";
        };
        "rust-analyzer.check.command" = "clippy";
        "rust-analyzer.serverPath" = "~/.nix-profile/bin/rust-analyzer";
        "nix.formatterPath" = "nixfmt";
      };
    };
  };
}
