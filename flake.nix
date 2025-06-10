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

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
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

    # Hoyo Launchers
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
    nixosConfigurations = {
      dotPC = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};

        modules = [
          nur.modules.nixos.default
          nix-flatpak.nixosModules.nix-flatpak
          aagl.nixosModules.default
          ./nixos/default.nix
          ./hosts/dotPC/configuration.nix
          {
            hoyo.enable = true;
            sunshine.enable = true;
            zerotier.enable = false;
            tailscale.enable = false;
            steam.enable = true;
            protonmail-bridge.enable = true;
            alvr.enable = true;
            # orca-slicer.enable = false;
          }
        ];
      };

      dotFW = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};

        modules = [
          nur.modules.nixos.default
          nix-flatpak.nixosModules.nix-flatpak
          nixos-hardware.nixosModules.framework-13-7040-amd
          aagl.nixosModules.default
          ./nixos/default.nix
          ./hosts/framework-13/configuration.nix
          {
            hoyo.enable = true;
            steam.enable = true;
            zerotier.enable = false;
            tailscale.enable = false;
            sunshine.enable = false;
            protonmail-bridge.enable = false;
            # orca-slicer.enable = true;
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
          inputs.plasma-manager.homeManagerModules.plasma-manager
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
          inputs.plasma-manager.homeManagerModules.plasma-manager
          inputs.nvf.homeManagerModules.default
        ];
      };
    };
  };
}
