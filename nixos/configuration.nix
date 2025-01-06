{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        experimental-features = "nix-command flakes";
        nix-path = config.nix.nixPath;
      };
      channel.enable = false;

      # Opinionated: make flake registry and nix path match flake inputs
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
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

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    libGL
    # Add missing dynamic libraries here instead of system
  ];

  # Docker
  virtualisation.docker.enable = true;
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "dotPC"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Set your time zone.
  time.timeZone = "Asia/Dubai";

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
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
    nerdfonts
    liberation_ttf
    google-fonts
    vistafonts
  ];

  programs.adb.enable = true;

  programs.fish = {
    enable = true;
    shellAbbrs = {
      ls = "ls -f";
      nc = "lvim ~/dotfiles/.";
      nco = "lvim ~/dotfiles/nixos/configuration.nix";
      nch = "lvim ~/dotfiles/home-manager/home.nix";
    };
    interactiveShellInit = "set -U fish_greeting";
  };

  programs.kdeconnect.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # programs.orca-slicer = {
  #   enable = true;
  #   openFirewall = true;
  # };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  # Set fish as the default shell
  # programs.bash = {
  #   interactiveShellInit = ''
  #     if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
  #     then
  #       shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
  #       exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
  #     fi
  #   '';
  # };

  services.zerotierone = {
    enable = true;
    localConf.settings.softwareUpdate = "disable";
  };

  services.sunshine = {
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

  # Flatpak applications
  services.flatpak = {
    enable = true;
    packages = [
      "io.mrarm.mcpelauncher" # Minecraft Bedrock Launcher
    ];
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.resolved.enable = true;

  services.tailscale.enable = true;

  # Enabled for Sunshine
  services.avahi.publish.enable = true;
  services.avahi.publish.userServices = true;

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # Open ports in the firewall.
  networking.firewall = {
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

  networking.nat = {
    enable = true;
    enableIPv6 = true;
    externalInterface = "eth0";
  };

  system.stateVersion = "23.11";
}
