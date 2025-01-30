{pkgs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Custom Modules
  sunshine.enable = false;
  zerotier.enable = false;
  tailscale.enable = true;

  # orca-slicer.enable = false;

  alvr.enable = false;

  # Docker
  virtualisation.docker.enable = true;
  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    plymouth = {
      enable = true;
      # theme = "rings";
      themePackages = with pkgs; [
        # By default we would install all themes
        breeze-plymouth
      ];
    };

    # Enable "Silent Boot"
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 0;
  };

  networking = {
    hostName = "dotFW";
    networkmanager.enable = true;

    firewall = {
      enable = false;
      # Enable multicast ports to discover local devices
      extraCommands = ''
        iptables -I INPUT -m pkttype --pkt-type multicast -j ACCEPT
        iptables -A INPUT -m pkttype --pkt-type multicast -j ACCEPT
        iptables -I INPUT -p udp -m udp --match multiport --dports 1989,2021 -j ACCEPT
      '';
      checkReversePath = false; # Get wireguard to work
      allowedTCPPorts = [
        9943
        9944
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
        9943
        9944
        53
        51820
        25565
        19132
      ];
    };

    nat = {
      enable = true;
      enableIPv6 = true;
    };
  };

  hardware = {
    framework = {
      enableKmod = true;
      # TODO: Remove after kernel 6.7
      #amd-7040.preventWakeOnAC = true;
    };

    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };

  # Set your time zone.
  time.timeZone = "America/Detroit";
  # Select internationalisation properties.

  services = {
    fwupd.enable = true;

    xserver = {
      enable = true;
      xkb.layout = "us";
      xkb.variant = "";
    };

    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;
    # displayManager.autoLogin.enable = true;
    # displayManager.autoLogin.user = "mdot";

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
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
  };
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [
    git
    wget
    wl-clipboard
    home-manager
    ripgrep
    fd
    sshfs
    cargo
    orca-slicer
    bitwarden-desktop
    hunspell # dictionary
    hunspellDicts.en_US
  ];

  systemd.targets = {
    # sleep.enable = false;
    # suspend.enable = false;
    # hibernate.enable = false;
    # hybrid-sleep.enable = false;
  };

  system.stateVersion = "24.11";
}
