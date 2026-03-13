# Gaming: Steam + CachyOS Proton + Gamemode + Gamescope
{ pkgs, ... }:

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
