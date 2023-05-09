{ inputs, ... }:
{
  imports = [
    ./global
    ./features/desktop/hyprland
    ./features/desktop/wireless
    ./features/rgb
    ./features/productivity
    #./features/pass
    ./features/games
    ./features/music
  ];

  wallpaper = (import ./wallpapers).towers-ice;
  colorscheme = inputs.nix-colors.colorSchemes.tokyo-city-terminal-dark;

  #  ------   ------   ------
  # |HDMI-1| | DP-2 | | DP-1 |
  #  ------   ------   ------
  monitors = [
    {
      name = "DP-3";
      width = 3840;
      height = 2160;
      noBar = true;
      x = 0;
      workspace = "3";
    }
    {
      name = "DP-2";
      width = 2560;
      height = 1440;
      refreshRate = 144;
      x = 3840;
      y = 768;
      workspace = "1";
    }
    {
      name = "DP-1";
      width = 3840;
      height = 2160;
      noBar = true;
      x = 6400;
      workspace = "2";
    }
  ];
}
