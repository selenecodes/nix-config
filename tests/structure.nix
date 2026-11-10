{lib}: let
  root = ../.;
  stack = root + "/modules/software/hyprland-caelestia";
  nixFiles = path: builtins.filter (file: lib.hasSuffix ".nix" (toString file)) (lib.filesystem.listFilesRecursive path);
  relative = path: lib.removePrefix "${toString root}/" (toString path);
  usesSharedTargeting = file:
    lib.any (
      line: builtins.match "(^|.*[^[:alnum:]_])hyprlandCaelestia([^[:alnum:]_].*|$)" line != null
    ) (lib.splitString "\n" (builtins.readFile file));
  legacySelectors = lib.concatMap (
    platform:
      map (profile: "config.${platform}.${profile}") [
        "base"
        "audio"
        "bluetooth"
        "networking"
        "nvidia"
        "gaming"
        "personal"
        "work"
      ]
  ) ["nixos" "darwin" "homeManager"];
in {
  testNoLegacyProfileSelectors = {
    expr = map relative (builtins.filter (
      file: lib.any (selector: lib.hasInfix selector (builtins.readFile file)) legacySelectors
    ) (nixFiles (root + "/modules")));
    expected = [];
  };
  testCoupledFeatureFilesExist = {
    expr = builtins.filter (name: !(builtins.pathExists (stack + "/${name}"))) [
      ".interconnected"
      "README.md"
      "default.nix"
    ];
    expected = [];
  };
  testCaelestiaModulesUseSharedTargeting = {
    expr = map relative (builtins.filter (
      file: file != stack + "/default.nix" && !(usesSharedTargeting file)
    ) (nixFiles stack));
    expected = [];
  };
}
