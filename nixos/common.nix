{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      nix-path = config.nix.nixPath;
    };
    channel.enable = false;
  };

  users.defaultUserShell = pkgs.fish;
  users.users.mdot = {
    isNormalUser = true;
    description = "Amaan";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "adbusers"
      "kvm"
    ];
    openssh.authorizedKeys.keys = [
      # SSH public Keys
    ];
  };
}
