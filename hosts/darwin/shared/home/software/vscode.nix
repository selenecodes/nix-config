{ pkgs, myFont, ... }:
# Add vscode mock since we're managing it through homebrew and the
# pkgs.vscode is an old version.
let
  vscode-mock = (pkgs.writeShellScriptBin "code" ''
    true
  '').overrideAttrs (oldAttrs: {
    pname = "vscode";
    version = "1.109.5";
  });
in {
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    package = vscode-mock;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # General
        gruntfuggly.todo-tree
        naumovs.color-highlight
        ms-vscode-remote.remote-ssh
        # Themes
        # ayakosky.fluffy-theme
        # mgwg.light-pink-theme
        # TOML
        tamasfe.even-better-toml
        # Helm
        tim-koehler.helm-intellisense
        # Docker & Containers
        ms-vscode-remote.remote-containers
        # ms-azuretools.vscode-containers
        ms-azuretools.vscode-docker
        # docker.docker
        # sashabusinaro.yaml-compose-sorter
        # Node & JS
        usernamehw.errorlens
        svelte.svelte-vscode
        # arktypeio.arkdark
        unifiedjs.vscode-mdx
        yoavbls.pretty-ts-errors
        # Python
        njpwerner.autodocstring
        charliermarsh.ruff
        #ms-python.debugpy
        ms-python.pylint
        ms-python.python
        ms-python.mypy-type-checker
        ms-pyright.pyright
        #ms-toolsai.jupyter
        #ms-toolsai.jupyter-renderers
        #ms-toolsai.jupyter-keymap
        #ms-toolsai.vscode-jupyter-cell-tags
        #ms-toolsai.vscode-jupyter-slideshow
        #ms-toolsai.datawrangler
        # Mermaid
        bierner.markdown-mermaid
        # Nix
        bbenoist.nix
        # Terraform
        hashicorp.hcl
        # Yaml
        redhat.vscode-yaml
        # Just syntax highlighting
        nefrob.vscode-just-syntax
        # vscodevim.vim
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "vscode-theme-onedark";
          publisher = "akamud";
          version = "2.3.0";
          sha256 = "sha256-8GGv4L4poTYjdkDwZxgNYajuEmIB5XF1mhJMxO2Ho84=";
        }
        {
          name = "atom-keybindings";
          publisher = "ms-vscode";
          version = "3.3.0";
          sha256 = "sha256-vzOb/DUV44JMzcuQJgtDB6fOpTKzq298WSSxVKlYE4o=";
        }
        {
          name = "vscode-versionlens";
          publisher = "pflannery";
          version = "1.22.4";
          sha256 = "sha256-yEhFRRwaqq4OH1oEjD2E+8y7DCVbvvvwa3r6ujq7IGg=";
        }
      ];
      userSettings = {
        "autoDocstring.docstringFormat" = "numpy-notypes";
        # Font family settings
        "editor.fontFamily" = "'${myFont}', monospace";
        "editor.fontSize" = 13;
        "editor.fontLigatures" = "'calt'";
        "debug.console.fontFamily" = "'${myFont}', monospace";
        "debug.console.fontSize" = 13;
        "terminal.integrated.fontFamily" = "'${myFont}', monospace";
        "terminal.integrated.fontSize" = 13;
        "terminal.integrated.fontLigatures.enabled" = "'calt'";
        # Other settings
        "chat.commandCenter.enabled" = false;
        "chat.disableAIFeatures" = true;
        "editor.formatOnPaste" = true;
        "editor.letterSpacing" = 0.4;
        "editor.smoothScrolling" = true;
        "editor.multiCursorModifier" = "ctrlCmd";
        "editor.rulers" = [80];
        "editor.tokenColorCustomizations" = {
          "textMateRules" = [
            {
              "name" = "Comment";
              "scope" = [
                "comment"
                "comment.block"
                "comment.block.documentation"
                "comment.line"
                "comment.line.double-slash"
                "punctuation.definition.comment"
              ];
              "settings" = {
                "fontStyle" = "italic";
                # "fontStyle" = "italic underline";
                # "fontStyle" = "italic bold underline";
              };
            }
          ];
        };
        "explorer.confirmDelete" = false;
        "explorer.confirmDragAndDrop" = false;
        "extensions.ignoreRecommendations" = true;
        "files.associations" = {
          "*.hcl" = "hcl";
          "*.tf" = "hcl";
          "*.tfvars" = "hcl";
          "*.yml" = "yaml";
          "*.env" = "shellscript";
        };
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "git.enableSmartCommit" = true;
        "git.replaceTagsWhenPull" = true;
        "javascript.updateImportsOnFileMove.enabled" = "always";
        "python.analysis.typeCheckingMode" = "strict";
        "python.createEnvironment.trigger" = "off";
        "python.terminal.activateEnvInCurrentTerminal" = false;
        "redhat.telemetry.enabled" = false;
        "security.workspace.trust.untrustedFiles" = "open";
        "svelte.enable-ts-plugin" = true;
        "telemetry.telemetryLevel" = "off";
        "terminal.integrated.inheritEnv" = true;
        "update.showReleaseNotes" = false;
        "window.zoomLevel" = 2;
        "workbench.colorTheme" = "Atom One Dark";
        "workbench.list.typeNavigationMode" = "trigger";
        "[python]"."editor.defaultFormatter" = "charliermarsh.ruff";
        "[restructuredtext]"."editor.wordWrap" = "on";
        "[markdown]"."files.trimTrailingWhitespace" = true;
      };
    };
  };
}
