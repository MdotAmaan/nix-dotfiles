{
  description = "Main Nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/master";
    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Plasma Manager
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declarative Flatpaks
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=v0.5.0";
    };

    nvf.url = "github:notashelf/nvf";

    # Firefox addons
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyvrse Launchers
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    nixpkgs-unstable,
    nvf,
    home-manager,
    plasma-manager,
    nix-flatpak,
    nix-on-droid,
    aagl,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    nixOnDroidConfigurations.dotTab = nix-on-droid.lib.nixOnDroidConfiguration {
      modules = [./hosts/sm-x710/dotTab-configuration.nix];
    };

    # NVF-configured Neovim
    packages."x86_64-linux".default =
      (nvf.lib.neovimConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        modules = [./neovim/nvf-configuration.nix];
      })
      .neovim;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      dotPC = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        # > Our main nixos configuration file <
        modules = [
          nix-flatpak.nixosModules.nix-flatpak
          ./nixos/default.nix
          ./hosts/dotPC/configuration.nix
          {
            imports = [aagl.nixosModules.default];
            nix.settings = aagl.nixConfig; # Set up Cachix
            programs.anime-game-launcher.enable = true; # Adds launcher and /etc/hosts rules
            programs.honkers-railway-launcher.enable = true;
          }
        ];
      };

      dotFW = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        # > Our main nixos configuration file <
        modules = [
          nix-flatpak.nixosModules.nix-flatpak
          nixos-hardware.nixosModules.framework-13-inch-7040-amd
          ./nixos/default.nix
          ./hosts/framework-13/configuration.nix

          {
            imports = [aagl.nixosModules.default];
            nix.settings = aagl.nixConfig; # Set up Cachix
            programs.anime-game-launcher.enable = true; # Adds launcher and /etc/hosts rules
            programs.honkers-railway-launcher.enable = true;
          }
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "mdot@dotPC" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {
          inherit inputs outputs;
          pkgs-unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
            overlays = [
            ];
          };
        };

        # > Our main home-manager configuration file <
        modules = [
          ./home-manager/default.nix
          ./hosts/dotPC/home.nix
          inputs.plasma-manager.homeManagerModules.plasma-manager
          inputs.nvf.homeManagerModules.default
        ];
      };

      "mdot@dotFW" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {
          inherit inputs outputs;
          pkgs-unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
            overlays = [
            ];
          };
        };
        # > Our main home-manager configuration file <
        modules = [
          ./home-manager/default.nix
          ./hosts/framework-13/home.nix
          inputs.plasma-manager.homeManagerModules.plasma-manager
          inputs.nvf.homeManagerModules.default
        ];
      };
    };
  };
}
