_: let
  timeZone = "Europe/Amsterdam";
in {
  nixos.base = {
    time.timeZone = timeZone;
    i18n.defaultLocale = "en_GB.UTF-8";
  };

  darwin.base = {
    time.timeZone = timeZone;
  };
}
