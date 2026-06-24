{ lib, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = lib.mkMerge [
      (lib.mkIf pkgs.stdenv.isDarwin {
        "Match host * exec \"test -z $SSH_CONNECTION\"" = {
          identityAgent = "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
        };
        "rwslaptop" = {
          hostname = "Bloks-MacBook-Air.local";
          user = "selene.blok";
          forwardAgent = true;
        };
      })
      (lib.mkIf (!pkgs.stdenv.isDarwin) {
        "Match host * exec \"test -z $SSH_CONNECTION\"" = {
          identityAgent = "~/.1password/agent.sock";
        };
      })
    ];
  };
}
