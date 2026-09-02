_: {
  repository.features = [
    {
      nixos = {
        targets = ["gayming" "rwslaptop"];
        module = {pkgs, ...}: {
          environment.systemPackages = with pkgs; [google-chrome firefox];
        };
      };
      darwin = {
        targets = ["studio"];
        module = _: {
          homebrew.casks = ["arc"];
        };
      };
    }
  ];
}
