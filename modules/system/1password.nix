_: {
  nixos.base = _: {
    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = ["selene"];
    };
  };
  darwin.base = _: {
    programs._1password.enable = true;
  };
}
