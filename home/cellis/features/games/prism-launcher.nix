{ pkgs, lib, ... }: {
  home.packages = [ pkgs.prismlauncher ];

  home.persistence = {
    "/persist/home/cellis".directories = [ ".local/share/PrismLauncher" ];
  };
}
