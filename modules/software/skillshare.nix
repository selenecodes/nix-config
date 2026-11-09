{inputs, ...}: {
  repository.features = [
    {
      homeManager = {
        targets = ["rwslaptop" "studio"];
        module = {pkgs, ...}: {
          home.packages = [inputs.skillshare.packages.${pkgs.stdenv.hostPlatform.system}.default];
        };
      };
    }
  ];
}
