{pkgs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Custom Modules
  sunshine.enable = true;
  zerotier.enable = false;
  tailscale.enable = true;
  steam.enable = true;
  # orca-slicer.enable = false;

  alvr.enable = false;

  # Docker
  virtualisation.docker.enable = true;
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
      checkReversePath = false;
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

    adb.enable = true;
    kdeconnect.enable = true;
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
    hunspell # dictionary
    hunspellDicts.en_US
  ];

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  system.stateVersion = "23.11";
}
