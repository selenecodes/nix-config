_: {
  repository.features = [
    {
      nixos = {
        targets = ["*"];
        module = {lib, ...}: {
          config.nix.settings.experimental-features = ["nix-command" "flakes"];

          options.myConfig.user.name = lib.mkOption {
            type = lib.types.str;
            description = "Primary user name for this host";
          };
        };
      };
    }
  ];
}
