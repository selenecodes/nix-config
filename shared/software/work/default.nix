# Work-related software
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    terraform
  ];
}
