{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # ./vfio.nix
  ];
  options = {
    gui = lib.mkOption {default = "kde";};
  };

  config = {
    host = "dotPC";
    gui = "kde";

    boot = {
      kernelParams = ["intel_iommu=on"];
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
        timeout = 0;
      };

      # Force older kernel to prevent AMDGPU crash. Remove once fix is applied upstream
      # kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_14.override {
      #   argsOverride = rec {
      #     src = pkgs.fetchurl {
      #       url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
      #       sha256 = "sha256-IYF/GZjiIw+B9+T2Bfpv3LBA4U+ifZnCfdsWznSXl6k=";
      #     };
      #     version = "6.14.6";
      #     modDirVersion = "6.14.6";
      #   };
      # });
    };

    virtualisation.docker.enable = true;

    networking = {
      hostName = config.host;
      networkmanager.enable = true;

      firewall = {
        enable = true;
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
          25565 # Minecraft Java
        ];
        # allowedTCPPortRanges = [
        #   {
        #   }
        # ];
        # allowedUDPPortRanges = [
        #   {
        #   }
        # ];
        allowedUDPPorts = [
          9943
          9944
          53
          51820
          19132 # Minecraft Server
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

    time.timeZone = "America/Detroit";

    services = {
      power-profiles-daemon.enable = true;
      xserver = {
        enable = true;
        xkb.layout = "us";
        xkb.variant = "";
      };

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
      appimage = {
        enabe = true;
        binfmt = true;
      };

      nix-ld.enable = true;
      nix-ld.libraries = with pkgs; [
        stdenv.cc.cc.lib
        zlib
        libGL
        # add missing dynamic libraries here instead of system
      ];

      partition-manager.enable = true;
      adb.enable = true;
      kdeconnect.enable = true;
    };

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;

    environment.systemPackages = with pkgs; [
      wget
      wl-clipboard
      home-manager
      ripgrep
      fd
      sshfs
      cargo
      darkly
      nur.repos.shadowrz.klassy-qt6
      qalculate-qt
      aspell
      aspellDicts.en
      aspellDicts.en-computers
      aspellDicts.en-science
    ];

    systemd.targets = {
      sleep.enable = true;
      suspend.enable = true;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };

    system.stateVersion = "23.11";
  };
}
