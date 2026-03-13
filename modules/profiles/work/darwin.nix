# Darwin-specific work software (Homebrew packages)
{ pkgs, ... }: {
  homebrew.brews = [
    "helm"
  ];

  homebrew.casks = [
    "citrix-workspace"
  ];
}
