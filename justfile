flake_dir := "~/nix-config"

build device:
  sudo darwin-rebuild switch --flake {{flake_dir}}#{{device}}

update:
  nix flake update --flake {{flake_dir}}

clean:
  nix-collect-garbage