{
  lib,
  config,
  ...
}: {
  options = {
    firefox.enable = lib.mkEnableOption "Enables Firefox";
  };

  config = lib.mkIf config.firefox.enable {
    programs.firefox = {
      enable = true;
      policies = {
        DontCheckDefaultBrowser = true;
        DisablePocket = true;
        DisableFirefoxStudies = true;
        OfferToSaveLogins = false;
        DisableFirefoxScreenshots = true;
        NoDefaultBookmarks = true;
        DNSOverHTTPS = {
          Enabled = true;
        };
      };
      profiles.mdot = {
        search = {
          force = true;
          default = "DuckDuckGo";
          engines = {
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                  updateInterval = 24 * 60 * 60 * 1000; # every day
                  definedAliases = "@np";
                }
              ];
            };
          };
        };
        settings = {
          "widget.use-xdg-desktop-portal.file-picker" = 1;
          "browser.compactmode.show" = true;
        };
      };
    };
  };
}
