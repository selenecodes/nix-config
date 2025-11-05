{ pkgs, ... }: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    ignores = [ "CLAUDE.local.md" ".claude" ];
    settings = {
      user.email = "selene.blok@gmail.com";
      user.name = "Selene Blok";
      push.autosetupremote = true;
      init.defaultbranch="main";
      credential.helper="manager";
      http."https://gitlab.at.rws.nl" = {
        sslKey  = "~/certs/gitlab-at-rws-nl-cert/git-rws-nl.key";
        sslCert = "~/certs/gitlab-at-rws-nl-cert/git-rws-nl.pem";
      };
      http."https://git.rws.nl" = {
        sslKey  = "~/certs/gitlab-at-rws-nl-cert/git-rws-nl.key";
        sslCert = "~/certs/gitlab-at-rws-nl-cert/git-rws-nl.pem";
      };
    };
    signing = {
      format = "openpgp";
      signByDefault = true;
    };
  };
}
