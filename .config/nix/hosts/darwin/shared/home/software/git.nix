{ pkgs, ... }: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Selene Blok";
    userEmail = "selene.blok@gmail.com";
    ignores = [ "CLAUDE.local.md" ".claude" ];
    extraConfig = {
      push.autosetupremote = true;
      init.defaultbranch="main";
      http."https://gitlab.at.rws.nl" = {
        sslKey  = "~/certs/gitlab-at-rws-nl-cert/git-rws-nl.key";
        sslCert = "~/certs/gitlab-at-rws-nl-cert/git-rws-nl.pem";
      };
      http."https://git.rws.nl" = {
        sslKey  = "~/certs/gitlab-at-rws-nl-cert/git-rws-nl.key";
        sslCert = "~/certs/gitlab-at-rws-nl-cert/git-rws-nl.pem";
      };
      credential."https://github.com" = {
        helper = "manager";
        credentialStore = "cache";
        username = "selenecodes";
      };
    };
    signing = {
      format = "openpgp";
      signByDefault = true;
    };
  };
}
