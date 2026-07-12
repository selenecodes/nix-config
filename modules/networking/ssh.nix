_: {
  nixos.networking = _: {
    services.openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };
  };
  homeManager.base = {
    pkgs,
    lib,
    ...
  }: {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = lib.mkIf pkgs.stdenv.isDarwin {
        "rwslaptop" = {
          hostname = "Bloks-MacBook-Air.local";
          user = "selene.blok";
          forwardAgent = true;
        };
      };
    };
  };
}
