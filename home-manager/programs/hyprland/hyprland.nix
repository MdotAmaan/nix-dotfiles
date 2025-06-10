{
  lib,
  pkgs,
  osConfig,
  # pkgs-unstable,
  inputs,
  ...
}: {
  config = lib.mkIf (osConfig.gui == "hyprland") {
    home.packages = with pkgs;
      [
        wlogout
        gammastep
        grim
        grimblast
        hyprpicker
        foot
        fuzzel
        imagemagick
        socat
        trash-cli
        wayfreeze
        wl-screenrec
        xdg-user-dirs
        python313Packages.materialyoucolor
      ]
      ++ [
        inputs.quickshell.packages."x86_64-linux".default
        # pkgs-unstable.app2unit
      ];

    programs = {
      hyprlock = {
        enable = true;
      };
    };
    services = {
      hypridle = {
        enable = true;
      };

      hyprpaper = {
        enable = true;
      };

      jq = {
        enable = true;
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "$mod" = "SUPER";
        bind =
          [
            "$mod, F, exec, firefox"
            ", Print, exec, grimblast copy area"
          ]
          ++ (
            # workspaces
            # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
            builtins.concatLists (builtins.genList (
                i: let
                  ws = i + 1;
                in [
                  "$mod, code:1${toString i}, workspace, ${toString ws}"
                  "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
                ]
              )
              9)
          );
      };
    };
  };
}
