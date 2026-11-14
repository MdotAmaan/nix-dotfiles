{
  pkgs,
  lib,
  ...
}: {
  programs.ssh = {
    startAgent = true;
    enableAskPassword = true;
    # askPassword = pkgs.lib.mkForce "${pkgs.kdePackages.ksshaskpass.out}/bin/ksshaskpass";
    extraConfig = ''
      Host github.com
      IdentityFile ~/.ssh/key2
    '';
  };
  services.gnome.gcr-ssh-agent.enable = lib.mkForce false;
  services.gnome.gnome-keyring.enable = lib.mkForce false;
  environment.variables = {
    SSH_ASKPASS_REQUIRE = "prefer";
  };
}
