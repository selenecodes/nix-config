{
  hyprlandCaelestia,
  inputs,
  ...
}: {
  repository.features = [
    (hyprlandCaelestia.homeManager (
      {
        config,
        lib,
        pkgs,
        ...
      }: {
        config = lib.mkIf config.programs.vscode.enable {
          programs.vscode = {
            mutableExtensionsDir = true;
            profiles.default.userSettings."workbench.colorTheme" = "Caelestia";
          };

          home.activation.removeLegacyVscodeExtensionsLink = lib.hm.dag.entryBefore ["linkGeneration"] ''
            if [ -L "$HOME/.vscode/extensions" ]; then
              target="$(${pkgs.coreutils}/bin/readlink "$HOME/.vscode/extensions")"
              case "$target" in
                /nix/store/*) run ${pkgs.coreutils}/bin/rm "$HOME/.vscode/extensions" ;;
              esac
            fi
          '';

          home.activation.installCaelestiaVscodeExtension = lib.hm.dag.entryAfter ["linkGeneration"] ''
            if [ ! -d "$HOME/.vscode/extensions/soramanew.caelestia-vscode-integration-1.2.0" ]; then
              run ${pkgs.vscode}/bin/code --install-extension \
                ${inputs.caelestia-dots}/vscode/caelestia-vscode-integration/caelestia-vscode-integration-1.2.0.vsix
            fi
          '';
        };
      }
    ))
  ];
}
