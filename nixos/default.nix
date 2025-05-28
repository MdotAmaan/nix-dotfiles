{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./programs/default.nix
    ./services/default.nix
    ./fonts.nix
  ];

  options = {
    host = lib.mkOption {
      type = lib.types.string;
    };
  };

  config = {
    nix = {
      settings = {
        experimental-features = "nix-command flakes";
        nix-path = config.nix.nixPath;
        always-allow-substitutes = true;
      };
      channel.enable = false;
    };

    users.defaultUserShell = pkgs.zsh;
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

    nixpkgs = {
      overlays = [
      ];
      config = {
        allowUnfree = true;
      };
    };

    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_GB.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_GB.UTF-8";
    };

    environment.variables = {
      SSH_ASKPASS_REQUIRE = "prefer";
    };

    programs = {
      gnupg.agent = {
        enable = true;
        # enableSSHSupport = true;
      };
    };
  };
}
