{ pkgs, inputs, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-nvidia
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    ../common/global
    ../common/users/cellis

    ../common/optional/gamemode.nix
    ../common/optional/ckb-next.nix
    ../common/optional/greetd.nix
    ../common/optional/pipewire.nix
    ../common/optional/quietboot.nix
    # ../common/optional/lol-acfix.nix
    # ../common/optional/starcitizen-fixes.nix

  ];

  # TODO: theme "greeter" user GTK instead of using cellis to login
  services.greetd.settings.default_session.user = "cellis";

  networking = {
    hostName = "cumputer";
    useDHCP = true;
    interfaces.enp8s0 = {
      useDHCP = true;
      wakeOnLan.enable = true;

       ipv4 = {
        addresses = [{
          address = "192.168.8.15";
          prefixLength = 24;
        }];
      };
      ipv6 = {
        addresses = [{
          address = "fe80::a157:919d:a586:f776";
          prefixLength = 64;
        }];
      };
    };
  };

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    binfmt.emulatedSystems = [ "aarch64-linux" "i686-linux" ];
  };

  programs = {
    adb.enable = true;
    dconf.enable = true;
    kdeconnect.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  hardware = {
    nvidia = { # No idea if I need this?
      prime.offload.enable = false;
      modesetting.enable = true;
    };
    opengl = {
      enable = true;
      # extraPackages = with pkgs; [ amdvlk ]; # Do I replace this one with something?
      driSupport = true;
      driSupport32Bit = true;
    };
    openrgb.enable = true;
    # opentabletdriver.enable = true;
  };

  system.stateVersion = "22.11";
}
