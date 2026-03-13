# Darwin-specific work software (Homebrew packages)
{ ... }: {
  homebrew.brews = [
    "helm"
    "libpq"
    "minikube"
    "socket_vmnet"
    "qemu"
    "terragrunt"
  ];

  homebrew.casks = [
    "citrix-workspace"
    "miniconda"
    "slack"
  ];
}
