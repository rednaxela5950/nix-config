{ pkgs, lib, ... }: {
  home.packages = [ pkgs.osu-lazer ];

  home.persistence = {
    "/persist/home/cellis".directories = [ ".local/share/osu" ];
  };
}
