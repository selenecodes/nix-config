_: {
  nixos.base = {
    lib,
    pkgs,
    ...
  }: {
    options.myConfig.user.name = lib.mkOption {
      type = lib.types.str;
      description = "Primary user name for this host";
    };

    config = {
      environment.systemPackages = with pkgs; [
        wget
        curl
        pinentry-qt
        signal-desktop
      ];

      virtualisation.docker.enable = true;
    };
  };
}
