{ pkgs, ... }: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    ignores = [ "CLAUDE.local.md" ".claude" ];
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
      format = "ssh";
      signer = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      signByDefault = true;
      key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7XD47kGwOQQetoxcQOb4TvoqNyNc7LopmaRTkrsxyt7AAtArHIHhX1107tnSfmArgAYf4PPxonoiNfzO5i0HiT11zy9JK1CbrwIWN87zSW1npl9kaQowXMbWC+2OeixTPRIaOh5l6rsUQbuJBZUaHghznXFqtWZpoyhuHub7hOaFahun3ySoAz9gtKz0cuA+g5JxkoqG/mzr+y11iVR1Tn+n0jqRQPPodOehKHYLnQJT5fEvyVHP459qMWgICPPtHl4+YuwO4hBiUpZvHikOeYsDl0cplc8uGHzn95dxs1zfxStCYesdGn7maEFvfREgw8cNOzRh5WGRJJDbkqQiKbPYkD9TjOTNorysJaS3cE4BIeRQFraJRinWRiMvVTsVSXI/XD+CT1WjP/IyYcsNfFbgbsljssVZceMGxmUkE3i9STB8t+RqhXg05JO87bCAofzPlPLskHGBqsM1eS/1QItadXeKS2ttu0agpdo0/i2O1PjEABYnVE/zhvJ/mqjc=";
    };
  };
}
