# Darwin-specific work software (Homebrew packages)
{ pkgs, ... }: {
  homebrew.brews = [
    "helm"
    "azure-cli"
  ];

  homebrew.casks = [
    "citrix-workspace"
  ];
}
