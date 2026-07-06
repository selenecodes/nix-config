{ lib, ... }: {
  options.myconfig = {
    isWork = lib.mkEnableOption "work profile";
    isPersonal = lib.mkEnableOption "personal profile";
    isGaming = lib.mkEnableOption "gaming profile";
  };
}
