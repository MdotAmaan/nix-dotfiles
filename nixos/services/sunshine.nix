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
            name = "Tab Session";
            prep-cmd = [
              {
                # TODO: Add conditions for laptop / desktop
                do = "${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.DP-3.mode.1680x1050@160";
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
