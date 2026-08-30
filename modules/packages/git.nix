let
  systemPackages = pkgs: with pkgs; [git-credential-manager lazygit];
  rwsSslConfig = {
    sslKey = "~/certs/gitlab-at-rws-nl-cert/git-rws-nl.key";
    sslCert = "~/certs/gitlab-at-rws-nl-cert/git-rws-nl.pem";
  };
in
  _: {
    nixos.base = {pkgs, ...}: {
      environment.systemPackages = systemPackages pkgs;
    };
    darwin.base = {pkgs, ...}: {
      environment.systemPackages = systemPackages pkgs;
      homebrew.casks = ["git-credential-manager"];
    };
    homeManager.base = {
      lib,
      config,
      pkgs,
      ...
    }: {
      options.myConfig.git.signing = {
        key = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
        };
        sshSignProgram = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
        };
      };

      config.programs.git = {
        enable = true;
        lfs.enable = true;
        ignores = ["CLAUDE.local.md" ".claude"];
        includes = [
          {
            condition = "gitdir:~/Documents/code/rws/";
            contents = {
              user = {
                email = "selene.blok@rws.nl";
              };
            };
          }
        ];
        settings = {
          user.email = "selene.blok@gmail.com";
          user.name = "Selene Blok";
          push.autosetupremote = true;
          init.defaultbranch = "main";
          credential.helper = "manager";
          credential.credentialStore =
            if pkgs.stdenv.hostPlatform.isDarwin
            then "keychain"
            else if pkgs.stdenv.hostPlatform.isLinux
            then "secretservice"
            else null;
          http."https://gitlab.at.rws.nl" = rwsSslConfig;
          http."https://git.rws.nl" = rwsSslConfig;
        };
        signing = lib.mkIf (config.myConfig.git.signing.key != null) {
          format = "ssh";
          signByDefault = true;
          key = config.myConfig.git.signing.key;
          signer =
            lib.mkIf (config.myConfig.git.signing.sshSignProgram != null)
            config.myConfig.git.signing.sshSignProgram;
        };
      };
    };
  }
