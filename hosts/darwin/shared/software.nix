# Applications that should be installed on all darwin devices. Please note that
# applications which are configured through home-manager go in the
# ./home/{appname}.nix folder and will be installed from there. DO NOT DUPLICATE
# THESE APPS HERE!
{ ... }: {
  imports = [
    ../../../shared/software/common/default.nix
    ../../../shared/software/common/darwin.nix
    ../../../shared/software/work/default.nix
    ../../../shared/software/work/darwin.nix
    ../../../shared/software/personal/darwin.nix
  ];
}
