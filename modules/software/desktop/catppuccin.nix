_: {
  repository.features = [
    {
      homeManager = {
        targets = ["gayming" "rwslaptop" "studio"];
        module = {pkgs, ...}: {
          catppuccin = {
            enable = pkgs.stdenv.hostPlatform.isDarwin;
            flavor = "frappe";
          };
        };
      };
    }
  ];
}
