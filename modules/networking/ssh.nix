_: {
  nixos.networking = _: {
    services.openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };
  };
}
