_: {
  nixos.work = {
    config,
    lib,
    pkgs,
    ...
  }: {
    options.myConfig.citrix.enable = lib.mkEnableOption "Citrix Workspace";

    config.environment.systemPackages = lib.optional config.myConfig.citrix.enable pkgs.citrix-workspace;
  };

  darwin.work = _: {
    homebrew.casks = ["citrix-workspace"];
  };
}
