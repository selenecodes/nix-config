_: {
  repository.features = [
    {
      nixos = {
        targets = ["*"];
        module = {config, ...}: {
          services.openssh = {
            enable = true;
            settings = {
              PasswordAuthentication = false;
              KbdInteractiveAuthentication = false;
              PermitRootLogin = "no";
              X11Forwarding = false;
              AllowAgentForwarding = true;
              AllowUsers = [config.myConfig.user.name];
            };
          };
        };
      };
      homeManager = {
        targets = ["*"];
        module = {
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
              (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
                "gayming" = {
                  hostname = "10.10.50.10";
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
      };
    }
  ];
}
