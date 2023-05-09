{ lib, pkgs, ... }: {
  home = {
    packages = [ pkgs.factorio ];
    persistence = {
      "/persist/home/cellis" = {
        allowOther = true;
        directories = [ ".factorio" ];
      };
    };
  };
}
