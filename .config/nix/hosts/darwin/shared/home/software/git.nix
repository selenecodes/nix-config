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
    };
    signing = {
      format = "openpgp";
      signByDefault = true;
    };
  };
}
