{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    sunshine.enable = lib.mkEnableOption "Enables Sunshine";
  };

  config = lib.mkIf config.sunshine.enable {
    services = {
      sunshine = {
        autoStart = true;
        capSysAdmin = true;
        enable = true;
        openFirewall = true;
        applications.apps = [
          {
            name = "1440p 16:9";
            prep-cmd = [
              {
                # TODO: Add conditions for laptop / desktop
                do = "${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.DP-3.mode.2560x1440@160";
                undo = "${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.DP-3.mode.3440x1440@160";
              }
            ];
            exclude-global-prep-cmd = "false";
            auto-detach = "true";
          }
          {
            name = "1080p 16:10";
            prep-cmd = [
              {
                # TODO: Add conditions for laptop / desktop
                do = "${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.DP-3.mode.1920x1200@160";
                undo = "${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.DP-3.mode.3440x1440@160";
              }
            ];
            exclude-global-prep-cmd = "false";
            auto-detach = "true";
          }
          {
            name = "1080p 16:9";
            prep-cmd = [
              {
                # TODO: Add conditions for laptop / desktop
                do = "${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.DP-3.mode.1920x1080@160";
                undo = "${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.DP-3.mode.3440x1440@160";
              }
            ];
            exclude-global-prep-cmd = "false";
            auto-detach = "true";
          }
          {
            name = "Unscaled";
            exclude-global-prep-cmd = "false";
            auto-detach = "true";
          }
        ];
      };
      avahi.publish.enable = true;
      avahi.publish.userServices = true;
    };
  };
}
