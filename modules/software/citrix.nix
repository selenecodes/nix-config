_: {
  repository.features = [
    {
      nixos = {
        targets = ["rwslaptop"];
        module = {
          config,
          lib,
          pkgs,
          ...
        }: {
          options.myConfig.citrix.enable = lib.mkEnableOption "Citrix Workspace";

          config.environment.systemPackages = lib.optional config.myConfig.citrix.enable pkgs.citrix-workspace;
        };
      };

      darwin = {
        targets = ["studio"];
        module.homebrew.casks = ["citrix-workspace"];
      };
    }
  ];
}
