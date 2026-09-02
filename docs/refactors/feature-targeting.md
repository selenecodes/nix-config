# Feature targeting style

Each file below `modules/config/` or `modules/software/` contributes one feature record through `repository.features`.

## Use shared modules

Use the same module value for NixOS and Darwin when both platforms use the same configuration.

```nix
let
	packageModule = {pkgs, ...}: {
		environment.systemPackages = [pkgs.usbutils];
	};
in
	_: {
		repository.features = [
			{
				nixos = {
					targets = ["*"];
					module = packageModule;
				};
				darwin = {
					targets = ["*"];
					module = packageModule;
				};
			}
		];
	}
```

Use separate facets when the platforms need different packages, services, or configuration.

```nix
_: {
	repository.features = [
		{
			nixos = {
				targets = ["gayming"];
				module = {pkgs, ...}: {
					environment.systemPackages = [pkgs.solaar];
				};
			};
			darwin = {
				targets = ["studio"];
				module.homebrew.casks = ["openlogi"];
			};
		}
	];
}
```

## Use wildcards deliberately

Within a `nixos`, `darwin`, or `homeManager` facet, `targets = ["*"]` means every configured target for that module system. The framework expands the wildcard when it projects the feature.

Do not combine `"*"` with explicit target names. Use explicit names when a future host must not receive the feature automatically.

The current output names are `gayming`, `rwslaptop`, and `studio`. `mac-studio` is a directory name, not an output name.

## Use directory policy helpers

When several independent features have the same target policy, the directory `default.nix` exports a namespaced constructor. Child files use the constructor instead of repeating the facet shape.

```nix
_: {
	_module.args.common.system = module: {
		nixos = {
			targets = ["*"];
			inherit module;
		};
		darwin = {
			targets = ["*"];
			inherit module;
		};
	};
}
```

```nix
{common, ...}: {
	repository.features = [
		(common.system ({pkgs, ...}: {
			environment.systemPackages = [pkgs.bat];
		}))
	];
}
```

Use a directory name that explains the software domain. Do not use a host name for a generic feature group. Coupled directories include `.interconnected` and `README.md`.
