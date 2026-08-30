_: {
  nixos.networking = {config, ...}: {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        X11Forwarding = false;
        AllowAgentForwarding = false;
        AllowUsers = [config.myConfig.user.name];
      };
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
