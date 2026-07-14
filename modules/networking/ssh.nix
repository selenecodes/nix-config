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
    config,
    ...
  }: {
    options.myConfig.ssh.identityAgent = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };

    config.programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = lib.mkMerge [
        (lib.mkIf pkgs.stdenv.isDarwin {
          "rwslaptop" = {
            hostname = "Bloks-MacBook-Air.local";
            user = "selene.blok";
            forwardAgent = true;
          };
        })
        (lib.mkIf (config.myConfig.ssh.identityAgent != null) {
          "Match host * exec \"test -z $SSH_CONNECTION\"" = {
            identityAgent = config.myConfig.ssh.identityAgent;
          };
        })
      ];
    };
  };
}
