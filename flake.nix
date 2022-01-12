{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    declarative-cachix.url = "github:jonascarpay/declarative-cachix";
    impermanence.url = "github:RiscadoA/impermanence";

    nix-colors.url = "github:Misterio77/nix-colors/add-vim-scheme";

    utils.url = "github:numtide/flake-utils";

    # Projects being worked on
    projeto-bd = {
      url = "github:misterio77/BSI-SCC0540-projeto/1.4.0";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "utils";
      };
    };
    paste-misterio-me = {
      url = "github:misterio77/paste.misterio.me/0.3.3";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "utils";
      };
    };

  };

  outputs = { nixpkgs, home-manager, utils, ... }@inputs:
    let
      # My overlays, plus from external projects
      overlay = (import ./overlays);
      overlays = [ overlay inputs.nur.overlay inputs.projeto-bd.overlay inputs.paste-misterio-me.overlay ];

      # Make system configuration, given hostname and system type
      mkSystem = { hostname, system, users }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs system;
          };
          modules = [
            ./modules/nixos
            (./hosts + "/${hostname}")
            {
              networking.hostName = hostname;
              # Apply overlay and allow unfree packages
              nixpkgs = {
                inherit overlays;
                config.allowUnfree = true;
              };
              # Add each input as a registry
              nix.registry = nixpkgs.lib.mapAttrs'
                (n: v:
                  nixpkgs.lib.nameValuePair (n) ({ flake = v; }))
                inputs;
            }
            # System wide config for each user
          ] ++ nixpkgs.lib.forEach users
            (u: ./users + "/${u}" + /system-wide.nix);
        };
      # Make home configuration, given username, required features, and system type
      mkHome = { username, system, hostname, features ? [ ] }:
        home-manager.lib.homeManagerConfiguration {
          inherit username system;
          extraSpecialArgs = {
            inherit features hostname inputs system;
          };
          homeDirectory = "/home/${username}";
          configuration = ./users + "/${username}";
          extraModules = [
            ./modules/home-manager
            {
              nixpkgs = {
                inherit overlays;
                config.allowUnfree = true;
              };
            }
          ];
        };
    in
    {
      inherit overlay overlays;

      nixosConfigurations = {
        # Main PC
        atlas = mkSystem {
          hostname = "atlas";
          system = "x86_64-linux";
          users = [ "misterio" ];
        };
        # Laptop
        pleione = mkSystem {
          hostname = "pleione";
          system = "x86_64-linux";
          users = [ "misterio" ];
        };
        # Raspberry Pi 4B
        merope = mkSystem {
          hostname = "merope";
          system = "aarch64-linux";
          users = [ "misterio" ];
        };
        # Gf's PC
        maia = mkSystem {
          hostname = "maia";
          system = "x86_64-linux";
          users = [ "layla" "misterio" ];
        };
      };

      homeConfigurations = {
        "misterio@atlas" = mkHome {
          username = "misterio";
          hostname = "atlas";
          features = [ "cli" "games" "desktop-sway" "trusted" "persistence" "rgb" ];
          system = "x86_64-linux";
        };
        "misterio@pleione" = mkHome {
          username = "misterio";
          hostname = "pleione";
          features = [ "cli" "games" "desktop-sway" "trusted" "persistence" ];
          system = "x86_64-linux";
        };
        "misterio@merope" = mkHome {
          username = "misterio";
          hostname = "merope";
          features = [ "cli" "persistence" ];
          system = "aarch64-linux";
        };
        "misterio@maia" = mkHome {
          username = "misterio";
          hostname = "maia";
          features = [ "cli" "persistence" ];
          system = "x86_64-linux";
        };

        "layla@maia" = mkHome {
          username = "layla";
          hostname = "maia";
          system = "x86_64-linux";
        };
      };

      templates = import ./templates;

    } // utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system overlays; };
        hm = home-manager.defaultPackage."${system}";
      in
      {
        packages = pkgs // {
          generated-gtk-themes = pkgs.callPackage ./pkgs/generated-gtk-themes {
            nix-colors = inputs.nix-colors;
          };
          home-manager = hm;
        };

        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [ nixUnstable nixfmt rnix-lsp hm ];
        };
      });
}
