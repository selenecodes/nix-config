{hyprlandCaelestia, ...}: {
  repository.features = [
    (hyprlandCaelestia.homeManager ({
      config,
      lib,
      ...
    }: {
      config = lib.mkIf config.programs.zsh.enable {
        programs.zsh.initContent = lib.mkAfter ''
          if [[ -r "$HOME/.local/state/caelestia/sequences.txt" ]]; then
            cat "$HOME/.local/state/caelestia/sequences.txt"
          fi
        '';
      };
    }))
  ];
}
