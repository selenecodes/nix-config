# Gaming: Steam + CachyOS Proton + Gamemode + Gamescope
{ lib, pkgs, ... }:

{
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
        nv_powermizer_mode = 1;  # Prefer maximum performance
      };
    };
  };

  # gamemoded defaults to WantedBy=default.target, which causes it to start in
  # the greetd greeter session (before a D-Bus session bus exists), resulting in
  # "Connection reset by peer". Restrict it to graphical sessions only.
  systemd.user.services.gamemoded.wantedBy = lib.mkForce [ "graphical-session.target" ];

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  environment.systemPackages = with pkgs; [
    # proton-ge-bin    # GE-Proton — community Proton with extra game patches
    protonup-qt      # GUI to manage Proton/Wine versions
    mangohud         # In-game FPS / GPU / CPU overlay
    goverlay         # MangoHud configurator
    protontricks     # Winetricks wrapper for Proton
    wine             # Windows compatibility layer
    winetricks
    bottles          # Wine/Proton app manager
    lutris           # Multi-source game launcher
  ];
}
