{
  lib,
  config,
  ...
}: {
  options = {
    neovim.enable = lib.mkEnableOption "Enables neovim";
  };

  config = lib.mkIf config.neovim.enable {
    home.sessionVariables = {EDITOR = "neovide";} // (config.home.sessionVariables or {});

    programs = {
      neovide = {
        enable = true;
        settings = {
          font.normal = [];
          font.size = 9.0;
        };
      };

      nvf = {
        enable = true;
        settings = import ../neovim/nvf-configuration.nix;
      };
    };
  };
}
