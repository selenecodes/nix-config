_: let
  port = 11434;
in {
  nixos.base = {
    networking.firewall.allowedTCPPorts = [port];
  };

  homeManager.base = {
    services.ollama = {
      acceleration = "cuda";
      enable = true;
      host = "0.0.0.0";
      inherit port;
    };
  };
}
