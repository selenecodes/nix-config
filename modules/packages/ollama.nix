_: let
  port = 11434;
in {
  nixos.base = {
    config,
    lib,
    ...
  }: {
    networking.firewall.allowedTCPPorts = [port];

    home-manager.sharedModules = lib.optional config.hardware.nvidia.modesetting.enable {
      services.ollama.acceleration = "cuda";
    };
  };

  homeManager.base = {
    services.ollama = {
      enable = true;
      host = "0.0.0.0";
      inherit port;
    };
  };
}
