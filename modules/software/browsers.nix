_: {
  repository.features = [
    {
      nixos = {
        targets = ["*"];
        module = {pkgs, ...}: {
          environment.systemPackages = with pkgs; [google-chrome firefox];
        };
      };
      darwin = {
        targets = ["*"];
        module = _: {
          homebrew.casks = ["arc"];
        };
      };
    }
  ];
}
