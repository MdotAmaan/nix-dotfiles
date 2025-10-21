{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    steam.enable = lib.mkEnableOption "Enables Steam";
  };
  config = lib.mkIf config.steam.enable {
    programs.steam = {
      package = pkgs.steam.override {
        extraPkgs = pkgs':
          with pkgs'; [
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib # Provides libstdc++.so.6
            libkrb5
            keyutils
          ];
      };

      protontricks.enable = true;
      enable = true;
      remotePlay.openFirewall = true;
    };
  };
}
