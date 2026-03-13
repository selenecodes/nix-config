# Work-related software
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    libpq
    slack
    terraform
    terragrunt
  ];
}
