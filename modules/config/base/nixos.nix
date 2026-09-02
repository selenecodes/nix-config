_: {
  repository.features = [
    {
      nixos = {
        targets = ["*"];
        module = {
          lib,
          pkgs,
          ...
        }: {
          options.myConfig.user.name = lib.mkOption {
            type = lib.types.str;
            description = "Primary user name for this host";
          };
        };
      };
    }
  ];
}
