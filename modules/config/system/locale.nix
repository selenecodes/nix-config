_: let
  timeZone = "Europe/Amsterdam";
in {
  repository.features = [
    {
      nixos = {
        targets = ["gayming" "rwslaptop"];
        module = {
          time.timeZone = timeZone;
          i18n.defaultLocale = "en_GB.UTF-8";
        };
      };
      darwin = {
        targets = ["studio"];
        module.time.timeZone = timeZone;
      };
    }
  ];
}
