{ pkgs, lib, config, ... }:
lib.mkIf config.myconfig.isGaming {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  programs.gamemode = {
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

  # gamemoded starts before D-Bus exists in the greeter session without this
  systemd.user.services.gamemoded.wantedBy = lib.mkForce [ "graphical-session.target" ];

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

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
}
