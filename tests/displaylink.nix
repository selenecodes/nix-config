{self}: let
  host = self.nixosConfigurations.rwslaptop;
  inherit (host) config;
  package = host.pkgs.displaylink.override {
    linuxPackages = config.boot.kernelPackages;
  };
in {
  testEnabled = {
    expr = config.myConfig.displaylink.enable;
    expected = true;
  };
  testEvdiPackageUsesSelectedKernel = {
    expr = builtins.elem config.boot.kernelPackages.evdi.outPath (map (p: p.outPath) config.boot.extraModulePackages);
    expected = true;
  };
  testEvdiModuleLoaded = {
    expr = builtins.elem "evdi" config.boot.kernelModules;
    expected = true;
  };
  testServiceUsesSelectedPackage = {
    expr = config.systemd.services.dlm.serviceConfig.ExecStart;
    expected = "${package}/bin/DisplayLinkManager";
  };
  testMatchingPackageInstalled = {
    expr = builtins.elem package.outPath (map (p: p.outPath) config.environment.systemPackages);
    expected = true;
  };
}
