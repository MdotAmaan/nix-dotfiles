{
  lib,
  config,
  ...
}: {
  options = {
    floorp.enable = lib.mkEnableOption "Enables Floorp";
  };

  config = lib.mkIf config.floorp.enable {
    programs.floorp = {
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
          default = "ddg";
          privateDefault = "ddg";
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
        };
      };
    };
  };
}
