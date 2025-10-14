{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # General
        gruntfuggly.todo-tree
        naumovs.color-highlight
        # Themes
        # ayakosky.fluffy-theme
        # mgwg.light-pink-theme
        # TOML
        tamasfe.even-better-toml
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
        ms-python.vscode-pylance
        ms-python.python
        ms-python.black-formatter
        ms-python.debugpy
        ms-python.mypy-type-checker
        ms-python.flake8
        ms-python.isort
        ms-toolsai.jupyter
        ms-toolsai.vscode-jupyter-cell-tags
        # ms-toolsai.vscode-jupyter-renderers
        ms-toolsai.vscode-jupyter-slideshow
        ms-toolsai.datawrangler
        # Mermaid
        bierner.markdown-mermaid
        # Nix
        bbenoist.nix
        # Terraform
        hashicorp.hcl
        # Misc
        visualstudioexptteam.vscodeintellicode
        visualstudioexptteam.intellicode-api-usage-examples
        ms-vsliveshare.vsliveshare
        # vscodevim.vim
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "jupyter-keymap";
          publisher = "ms-toolsai";
          version = "1.1.2";
          sha256 = "sha256-9BLyBZzZ0Z6QQ05QSxFJYNZmZDc5O3eYkCxe/UsmKws=";
        }
        {
          name = "jupyter-renderers";
          publisher = "ms-toolsai";
          version = "1.3.0";
          sha256 = "sha256-GBqHvXikCgLGW7Xm05Iq1xqs8j9H9k9c8iASsAjA87I=";
        }
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
        {
          name = "claude-code";
          publisher = "anthropic";
          version = "2.0.15";
          sha256 = "sha256-TKN0IR/0pzbcusO1J9n7sodqbrmzw4u4EEXkmFKb3co=";
        }
      ];
      userSettings = {
        "autoDocstring.docstringFormat" = "numpy-notypes";
        "editor.formatOnPaste" = true;
        "editor.multiCursorModifier" = "ctrlCmd";
        "editor.rulers" = [80];
        "explorer.confirmDelete" = false;
        "explorer.confirmDragAndDrop" = false;
        "extensions.ignoreRecommendations" = true;
        "files.associations" = {
          "*.hcl" = "hcl";
          "*.tf" = "hcl";
          "*.tfvars" = "hcl";
        };
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "git.enableSmartCommit" = true;
        "git.replaceTagsWhenPull" = true;
        "javascript.updateImportsOnFileMove.enabled" = "always";
        "python.createEnvironment.trigger" = "off";
        "python.terminal.activateEnvInCurrentTerminal" = false;
        "security.workspace.trust.untrustedFiles" = "open";
        "terminal.integrated.fontSize" = 13;
        "terminal.integrated.inheritEnv" = true;
        "window.zoomLevel" = 2;
        "workbench.colorTheme" = "Atom One Dark";
        "workbench.list.typeNavigationMode" = "trigger";
        "yaml-compose-sorter.removeVersionKey" = true;
      };
    };
  };
}
