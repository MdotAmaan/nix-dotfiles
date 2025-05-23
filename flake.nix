{
  description = "Main Nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/master";
    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Plasma Manager
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    lightly.url = "github:Bali10050/Darkly";

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    # Declarative Flatpaks
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=v0.6.0";
    };

    nvf.url = "github:notashelf/nvf";

    # Firefox addons
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyvrse Launchers
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    nixpkgs-unstable,
    nvf,
    nur,
    home-manager,
    plasma-manager,
    nix-flatpak,
    aagl,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
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
          nur.modules.nixos.default
          nix-flatpak.nixosModules.nix-flatpak
          ./nixos/default.nix
          ./hosts/dotPC/configuration.nix
          {
            imports = [aagl.nixosModules.default];
            nix.settings = aagl.nixConfig; # Set up Cachix
            programs.honkers-railway-launcher.enable = true;
            programs.anime-game-launcher.enable = true;
          }
        ];
      };

      dotFW = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        # > Our main nixos configuration file <
        modules = [
          nur.modules.nixos.default
          nix-flatpak.nixosModules.nix-flatpak
          nixos-hardware.nixosModules.framework-13-7040-amd
          ./nixos/default.nix
          ./hosts/framework-13/configuration.nix
          {
            imports = [aagl.nixosModules.default];
            nix.settings = aagl.nixConfig; # Set up Cachix
            programs.anime-game-launcher.enable = true;
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
