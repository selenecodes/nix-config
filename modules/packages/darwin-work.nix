{ lib, config, ... }:
lib.mkIf config.myconfig.isWork {
  homebrew = {
    brews = [ "helm" "azure-cli" ];
    casks = [ "citrix-workspace" ];
  };
}
