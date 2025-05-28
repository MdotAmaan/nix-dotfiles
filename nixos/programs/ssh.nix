{pkgs, ...}: {
  programs.ssh = {
    startAgent = true;
    enableAskPassword = true;
    askPassword = pkgs.lib.mkForce "${pkgs.kdePackages.ksshaskpass.out}/bin/ksshaskpass";
    extraConfig = ''
      Host github.com
      IdentityFile ~/.ssh/key2
    '';
  };
}
