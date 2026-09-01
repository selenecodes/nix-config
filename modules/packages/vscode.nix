{inputs, ...}: {
  homeManager.base = {
    lib,
    pkgs,
    ...
  }: let
    myFont = "JetBrainsMono Nerd Font";
    isLinux = pkgs.stdenv.hostPlatform.isLinux;
  in {
    programs.vscode = {
      enable = true;
      mutableExtensionsDir = isLinux;
      package = pkgs.vscode;
      profiles.default = {
        extensions = with pkgs.vscode-extensions;
          [
            # General
            gruntfuggly.todo-tree
            naumovs.color-highlight
            ms-vscode-remote.remote-ssh
            # TOML
            tamasfe.even-better-toml
            # Helm
            tim-koehler.helm-intellisense
            # Docker & Containers
            ms-vscode-remote.remote-containers
            ms-azuretools.vscode-docker
            # Node & JS
            usernamehw.errorlens
            svelte.svelte-vscode
            unifiedjs.vscode-mdx
            yoavbls.pretty-ts-errors
            # Python
            njpwerner.autodocstring
            charliermarsh.ruff
            ms-python.pylint
            ms-python.python
            ms-python.mypy-type-checker
            ms-pyright.pyright
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
            # Theme is supplied by the writable Caelestia integration.
          ]
          ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
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
        userSettings =
          {
            "autoDocstring.docstringFormat" = "numpy-notypes";
            "editor.fontFamily" = "'${myFont}', monospace";
            "editor.fontSize" = 13;
            "editor.fontLigatures" = "'calt'";
            "debug.console.fontFamily" = "'${myFont}', monospace";
            "debug.console.fontSize" = 13;
            "terminal.integrated.fontFamily" = "'${myFont}', monospace";
            "terminal.integrated.fontSize" = 13;
            "terminal.integrated.fontLigatures.enabled" = "'calt'";
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
                  "settings"."fontStyle" = "italic";
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
            "security.workspace.trust.untrustedFiles" = "prompt";
            "svelte.enable-ts-plugin" = true;
            "telemetry.telemetryLevel" = "off";
            "terminal.integrated.inheritEnv" = true;
            "update.showReleaseNotes" = false;
            "window.zoomLevel" = 2;
            "workbench.list.typeNavigationMode" = "trigger";
            "[python]"."editor.defaultFormatter" = "charliermarsh.ruff";
            "[restructuredtext]"."editor.wordWrap" = "on";
            "[markdown]"."files.trimTrailingWhitespace" = true;
          }
          // lib.optionalAttrs isLinux {
            "workbench.colorTheme" = "Caelestia";
          };
      };
    };

    home.activation.removeLegacyVscodeExtensionsLink = lib.mkIf isLinux (
      lib.hm.dag.entryBefore ["linkGeneration"] ''
        if [ -L "$HOME/.vscode/extensions" ]; then
          target="$(${pkgs.coreutils}/bin/readlink "$HOME/.vscode/extensions")"
          case "$target" in
            /nix/store/*) run ${pkgs.coreutils}/bin/rm "$HOME/.vscode/extensions" ;;
          esac
        fi
      ''
    );

    home.activation.installCaelestiaVscodeExtension = lib.mkIf isLinux (
      lib.hm.dag.entryAfter ["linkGeneration"] ''
        run ${pkgs.vscode}/bin/code --install-extension \
          ${inputs.caelestia-dots}/vscode/caelestia-vscode-integration/caelestia-vscode-integration-1.2.0.vsix
      ''
    );
  };
}
