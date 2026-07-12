{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.myconfig.isWork {
  environment.systemPackages = with pkgs; [
    libpq
    slack
    terraform
    terragrunt
  ];
}
