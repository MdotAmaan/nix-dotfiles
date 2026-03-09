{
  description = "Main Nix config";

  inputs = {
    # Nixpkgs
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/master";
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
    # Home manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

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

    niri = {
      url = "github:sodiboo/niri-flake";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.noctalia-qs.follows = "noctalia-qs";
    };

    noctalia-qs = {
      url = "github:noctalia-dev/noctalia-qs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf.url = "github:notashelf/nvf";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-xr,
    nixos-hardware,
    nixpkgs-unstable,
    nvf,
    nur,
    home-manager,
    nix-flatpak,
    niri,
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
    nixosConfigurations = {
      dotPC = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};

        modules = [
          nur.modules.nixos.default
          nixpkgs-xr.nixosModules.nixpkgs-xr
          nix-flatpak.nixosModules.nix-flatpak
          ./nixos/default.nix
          ./hosts/dotPC/configuration.nix
          {
            sunshine.enable = true;
            zerotier.enable = false;
            tailscale.enable = false;
            steam.enable = true;
            protonmail-bridge.enable = true;
            alvr.enable = false;
          }
        ];
      };

      dotFW = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};

        modules = [
          nur.modules.nixos.default
          nix-flatpak.nixosModules.nix-flatpak
          nixos-hardware.nixosModules.framework-13-7040-amd
          ./nixos/default.nix
          ./hosts/framework-13/configuration.nix

          niri.nixosModules.niri
          {
            steam.enable = true;
            minecraft-server.enable = true;
            zerotier.enable = false;
            tailscale.enable = false;
            sunshine.enable = false;
            protonmail-bridge.enable = false;
          }
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    homeConfigurations = {
      "mdot@dotPC" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;

        extraSpecialArgs = {
          inherit inputs outputs;
          pkgs-unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
            overlays = [
            ];
          };
        };

        modules = [
          ./home-manager/default.nix
          ./hosts/dotPC/home.nix
          inputs.noctalia.homeModules.default
          inputs.plasma-manager.homeModules.plasma-manager
          inputs.nvf.homeManagerModules.default
        ];
      };

      "mdot@dotFW" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;

        extraSpecialArgs = {
          inherit inputs outputs;
          pkgs-unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
            overlays = [
            ];
          };
        };

        modules = [
          ./home-manager/default.nix
          ./hosts/framework-13/home.nix
          niri.homeModules.niri
          inputs.noctalia.homeModules.default
          inputs.plasma-manager.homeModules.plasma-manager
          inputs.nvf.homeManagerModules.default
        ];
      };
    };
  };
}
