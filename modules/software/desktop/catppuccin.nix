_: {
  homeManager.base = {pkgs, ...}: {
    catppuccin = {
      enable = pkgs.stdenv.hostPlatform.isDarwin;
      flavor = "frappe";
    };
  };
}
