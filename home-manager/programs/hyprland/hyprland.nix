{
  lib,
  pkgs,
  config,
  # osConfig,
  # pkgs-unstable,
  inputs,
  ...
}: {
  options = {
    hyprland.enable = lib.mkEnableOption "Enables Hyprland";
  };

  config = lib.mkIf config.hyprland.enable {
    home.packages = with pkgs;
      [
        bluez-tools
        brightnessctl
        cava
        ddcutil
        wlogout
        gammastep
        fish
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
        jq
        xdg-user-dirs

        python313Packages.materialyoucolor
        python313Packages.pyaudio
        python313Packages.numpy
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

        settings = {
          general = {
            lock_cmd = "pidof hyprlock || hyprlock";
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = "hyprctl dispatch dpms on";
          };

          listener = [
            {
              timeout = 360; # 6 mins
              on-timeout = "loginctl lock-session";
            }
            # {
            #   timeout = 600; # 10 mins
            #   on-timeout = "systemctl suspend-then-hibernate || loginctl suspend";
            # }
          ];
        };
      };

      hyprpaper = {
        enable = true;
        settings = {
          splash = false;
          preload = "$HOME/.local/state/caelestia/wallpaper/current";
          wallpaper = "$HOME/.local/state/caelestia/wallpaper/current";
        };
      };
    };

    systemd.user.services.quickshell = {
      enable = true;

      Unit = {
        Description = "Desktop shell";
        After = ["graphical-session.target"];
      };

      Service = {
        Type = "exec";
        ExecStart = "$HOME/nix-dotfiles/home-manager/programs/quickshell/run.fish";
        Restart = "on-failure";
        Slice = "app-graphical.slice";
      };

      Install = {
        WantedBy = ["graphical-session.target"];
      };
    };

    home.file = {
      "~/.config/hypr".source = "./hypr";
      "~/.config/uwsm".source = "./hypr/uwsm";
    };
    # wayland.windowManager.hyprland = {
    #   enable = true;
    # };
  };
}
