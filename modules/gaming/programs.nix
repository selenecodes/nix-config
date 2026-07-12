_: {
  nixos.gaming = {
    pkgs,
    lib,
    ...
  }: {
    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        gamescopeSession.enable = true;
        extraCompatPackages = [pkgs.proton-ge-bin];
      };

      gamemode = {
        enable = true;
        settings = {
          general.renice = 10;
          gpu = {
            apply_gpu_optimisations = "accept-responsibility";
            gpu_device = 0;
            nv_powermizer_mode = 1;
          };
        };
      };

      gamescope = {
        enable = true;
        capSysNice = true;
      };
    };

    # gamemoded starts before D-Bus exists in the greeter session without this
    systemd.user.services.gamemoded.wantedBy = lib.mkForce ["graphical-session.target"];

    environment.systemPackages = with pkgs; [
      protonup-qt
      mangohud
      goverlay
      protontricks
      wine
      winetricks
      bottles
      lutris
    ];
  };
}
