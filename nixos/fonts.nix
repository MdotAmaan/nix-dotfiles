{pkgs, ...}: {
  fonts.packages = with pkgs;
    [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif

      departure-mono
      poppins
      fira-code
      liberation_ttf
      google-fonts
      vista-fonts
      material-symbols
      ibm-plex
    ]
    ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
}
