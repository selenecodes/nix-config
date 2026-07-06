{ pkgs, lib, ... }: {
  programs._1password.enable = true;

  programs._1password-gui = lib.optionalAttrs pkgs.stdenv.isLinux {
    enable = true;
    polkitPolicyOwners = [ "selene" ];
  };
}
