{ pkgs, lib, ... }: {
  home.packages = [ pkgs.sublime-music ];
  home.persistence = {
    "/persist/home/cellis".directories = [ ".config/sublime-music" ];
  };
}
