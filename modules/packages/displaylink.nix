_: {
  nixos.work = {
    config,
    lib,
    pkgs,
    ...
  }: {
    options.myConfig.displaylink.enable = lib.mkEnableOption "DisplayLink";

    config = lib.mkIf config.myConfig.displaylink.enable {
      environment.systemPackages = [pkgs.displaylink];
      services.xserver.videoDrivers = ["displaylink" "modesetting"];
      systemd.services.dlm.wantedBy = ["multi-user.target"];
    };
  };

  darwin.work = _: {
    homebrew.casks = ["displaylink"];
  };
}
