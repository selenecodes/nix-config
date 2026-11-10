_: {
  repository.features = [
    {
      nixos = {
        targets = ["*"];
        module = {pkgs, ...}: {
          environment.systemPackages = [pkgs.pipewire.jack];
          services.pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
            extraConfig.pipewire."10-clock-rate" = {
              "context.properties" = {
                "default.clock.rate" = 48000;
                "default.clock.quantum" = 256;
                "default.clock.min-quantum" = 128;
                "default.clock.max-quantum" = 1024;
              };
            };
          };
          security.rtkit.enable = true;
        };
      };
    }
  ];
}
