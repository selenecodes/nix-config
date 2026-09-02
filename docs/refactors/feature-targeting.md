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

## Keep targeting with the feature

Each independent feature declares its own targets. Do not use audience directories such as `common/` or `work/`, or directory helpers that supply targets to otherwise independent features.

```nix
let
	packageModule = {pkgs, ...}: {
		environment.systemPackages = [pkgs.bat];
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

Use a directory only for a coupled feature whose files share one removal boundary. Coupled directories include `.interconnected` and `README.md`; their `default.nix` may provide the shared targeting policy described by that README.
