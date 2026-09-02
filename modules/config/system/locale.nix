_: let
  timeZone = "Europe/Amsterdam";
in {
  repository.features = [
    {
      nixos = {
        targets = ["*"];
        module = {
          time.timeZone = timeZone;
          i18n.defaultLocale = "en_GB.UTF-8";
        };
      };
      darwin = {
        targets = ["*"];
        module.time.timeZone = timeZone;
      };
    }
  ];
}
