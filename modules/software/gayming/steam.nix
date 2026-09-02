{gaymingNixosTargets, ...}: {
  repository.features = [
    {
      nixos = {
        targets = gaymingNixosTargets;
        module = {pkgs, ...}: {
          programs.steam = {
            enable = true;
            remotePlay.openFirewall = true;
            dedicatedServer.openFirewall = true;
            gamescopeSession.enable = true;
            extraCompatPackages = [pkgs.proton-ge-bin];
          };
        };
      };
    }
  ];
}
