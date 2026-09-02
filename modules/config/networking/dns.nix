let
  nameservers = [
    "1.1.1.1"
    "1.0.0.1"
    "2606:4700:4700::1111"
    "2606:4700:4700::1001"
  ];
in
  _: {
    repository.features = [
      {
        nixos = {
          targets = ["*"];
          module.networking.nameservers = nameservers;
        };
        darwin = {
          targets = ["*"];
          module.networking.dns = nameservers;
        };
      }
    ];
  }
