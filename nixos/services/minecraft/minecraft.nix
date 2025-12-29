{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.nix-minecraft.nixosModules.minecraft-servers];
  options = {
    minecraft-server.enable = lib.mkEnableOption "Enables minecraft server";
  };

  config = lib.mkIf config.minecraft-server.enable {
    nixpkgs.overlays = [inputs.nix-minecraft.overlay];

    services.minecraft-servers = {
      enable = true;
      eula = true;

      servers = {
        cool-server-1 = {
          enable = true;
          package = pkgs.fabricServers.fabric-1_21_11;
          # jvmOpts = "-Xms4092M -Xmx4092M -XX:+UseG1GC";

          serverProperties = {
            server-port = 25565;

            gamemode = "survival";
            online-mode = "false";
            view-distance = 16;
            difficulty = "easy";
          };

          symlinks = {
            "mods" = ./cool-server-1/mods;
            "world" = ./cool-server-1/world;
          };
        };
      };
    };
  };
}
