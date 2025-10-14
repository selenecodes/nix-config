# Dotfiles
This is my dotfiles repository containing the configs of various applications.
Simply clone this repo into your home directory and run the commands below.

## How to run my nix config?
1. Clone this repository to your home folder
2. Install nix from https://nixos.org/download/.
3. Run the following to add the files of this repo to your home directory
```bash
nix shell --extra-experimental-features "nix-command flakes"
```
4. Initialize nix-darwin:
```bash
sudo nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/nix-config#studio
```
5. Rebuild the nix configuration whenever you wish.
```bash
sudo darwin-rebuild switch --flake ~/nix-config#studio
```

*For the inspiration of this configuration see: [Dreams of Autonomy - Nix is my favorite package manager on macOS](https://www.youtube.com/watch?v=Z8BL8mdzWHI)*