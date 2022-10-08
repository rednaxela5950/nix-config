# This file (and the global directory) holds config that i use on all hosts
{ lib, inputs, hostname, persistence, ... }:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
    ./acme.nix
    ./distributed-builds.nix
    ./fish.nix
    ./locale.nix
    ./tailscale.nix
    ./nix.nix
    ./openssh.nix
    ./podman.nix
    ./postgres.nix
    ./sops.nix
  ];

  networking = {
    hostName = hostname;
    domain = "m7.rs";
  };

  environment = {
    loginShellInit = ''
      # Activate home-manager environment, if not already
      [ -d "$HOME/.nix-profile" ] || /nix/var/nix/profiles/per-user/$USER/home-manager/activate &> /dev/null
    '';

    # Persist logs, timers, etc
    persistence = lib.mkIf persistence {
      "/persist".directories = [ "/var/lib/systemd" "/var/log" "/srv" ];
    };

    # Add terminfo files
    enableAllTerminfo = true;
  };

  # Allows users to allow others on their binds
  programs.fuse.userAllowOther = true;

  hardware.enableRedistributableFirmware = true;

  # Increase open file limit for sudoers
  security.pam.loginLimits = [
    {
      domain = "@wheel";
      item = "nofile";
      type = "soft";
      value = "524288";
    }
    {
      domain = "@wheel";
      item = "nofile";
      type = "hard";
      value = "1048576";
    }
  ];
}
