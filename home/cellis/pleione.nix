{ inputs, ... }:
{
  imports = [
    ./global
    ./features/desktop/hyprland
    ./features/desktop/wireless
    ./features/productivity
    ./features/pass
    ./features/games
  ];

  wallpaper = (import ./wallpapers).aenami-lunar;
  colorscheme = inputs.nix-colors.colorSchemes.atelier-heath;

  monitors = [{
    name = "eDP-1";
    width = 1920;
    height = 1080;
    workspace = "1";
  }];
}
