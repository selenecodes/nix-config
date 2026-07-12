_: {
  nixos.work = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      libpq
      slack
      terraform
      terragrunt
    ];
  };
  darwin.work = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      libpq
      slack
      terraform
      terragrunt
    ];
  };
}
