let
  nameservers = [
    "1.1.1.1"
    "1.0.0.1"
    "2606:4700:4700::1111"
    "2606:4700:4700::1001"
  ];
in
  _: {
    nixos.networking = _: {
      networking.nameservers = nameservers;
    };
    darwin.base = _: {
      networking.dns = nameservers;
    };
  }
