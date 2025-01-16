{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      nix-path = config.nix.nixPath;
    };
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  nixpkgs = {
    overlays = [
      # inputs.nix-minecraft.overlay
    ];
    config = {
      allowUnfree = true;
    };
  };

  # Docker
  virtualisation.docker.enable = true;
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "dotPC";
    networkmanager.enable = true;

    firewall = {
      # Enable multicast ports to discover local devices
      extraCommands = ''
        iptables -I INPUT -m pkttype --pkt-type multicast -j ACCEPT
        iptables -A INPUT -m pkttype --pkt-type multicast -j ACCEPT
        iptables -I INPUT -p udp -m udp --match multiport --dports 1989,2021 -j ACCEPT
      '';
      checkReversePath = false;
      # extraStopCommands = ''
      #   ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
      #   ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
      # '';
      allowedTCPPorts = [
        53
        25565
        19132
      ];
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        } # KDE Connect
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        } # KDE Connect
      ];
      allowedUDPPorts = [
        53
        51820
        25565
        19132
      ];
    };

    nat = {
      enable = true;
      enableIPv6 = true;
      externalInterface = "eth0";
    };
  };

  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };

  # Set your time zone.
  time.timeZone = "America/Detroit";
  # Select internationalisation properties.
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

  services = {
    xserver = {
      enable = true;
      xkb.layout = "us";
      xkb.variant = "";
    };

    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    sunshine = {
      autoStart = true;
      capSysAdmin = true;
      enable = true;
      openFirewall = true;
      applications.apps = [
        {
          name = "Tab Session";
          prep-cmd = [
            {
              do = "${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.DP-3.mode.1680x1050@160";
              undo = "${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.DP-3.mode.3440x1440@160";
            }
          ];
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
        {
          name = "Unscaled";
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
      ];
    };
    avahi.publish.enable = true;
    avahi.publish.userServices = true;

    zerotierone = {
      enable = true;
      localConf.settings.softwareUpdate = "disable";
    };

    tailscale.enable = true;

    flatpak = {
      enable = true;
      packages = [
        "io.mrarm.mcpelauncher" # Minecraft Bedrock Edition Launcher
      ];
    };

    openssh.enable = true;
    resolved.enable = true;

    printing.enable = true;
  };

  programs = {
    nix-ld.enable = true;
    nix-ld.libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      libGL
      # add missing dynamic libraries here instead of system
    ];

    fish = {
      enable = true;
      shellAbbrs = {
        ls = "ls -f";
        nc = "nvim ~/dotfiles/.";
        nco = "nvim ~/dotfiles/nixos/configuration.nix";
        nch = "nvim ~/dotfiles/home-manager/home.nix";
      };
      interactiveShellInit = "set -u fish_greeting";
    };

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    adb.enable = true;
    kdeconnect.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };

    # Awaiting PR #362630
    # orca-slicer = {
    #   enable = true;
    #   openFirewall = true;
    # };
  };

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

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

  environment.systemPackages = with pkgs; [
    git
    wget
    wl-clipboard
    home-manager
    ripgrep
    fd
    sshfs
    cargo
    firefox
    thunderbird
    kdePackages.kdeconnect-kde
    sunshine
    orca-slicer
    hunspell # dictionary
    hunspellDicts.en_US
    # fish stuff
    fishPlugins.autopair
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    nerdfonts
    liberation_ttf
    google-fonts
    vistafonts
  ];

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  system.stateVersion = "23.11";
}
