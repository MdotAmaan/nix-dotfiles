{
  lib,
  config,
  inputs,
  ...
}: {
  options = {
    hoyo.enable = lib.mkEnableOption "Enables hoyo launchers";
  };

  config = lib.mkIf config.hoyo.enable {
    nix.settings = inputs.aagl.nixConfig; # Set up Cachix
    programs.anime-game-launcher.enable = true;
    programs.honkers-railway-launcher.enable = true;
  };
}
