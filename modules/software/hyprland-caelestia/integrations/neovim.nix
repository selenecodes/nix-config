{
  hyprlandCaelestia,
  inputs,
  lib,
  ...
}: {
  repository.features = [
    (hyprlandCaelestia.homeManager ({config, ...}: {
      config = lib.mkIf config.programs.neovim.enable {
        xdg.configFile."nvim/colors/caelestia.lua".source = "${inputs.caelestia-dots}/nvim/colors/caelestia.lua";
        programs.neovim.initLua = ''
          vim.cmd.colorscheme("caelestia")
        '';
      };
    }))
  ];
}
