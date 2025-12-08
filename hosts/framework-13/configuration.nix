{
  pkgs,
  config,
  # inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  config = {
    host = "dotFW";

    virtualisation.docker.enable = true;

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
          kdePackages.breeze-plymouth
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
      loader.timeout = 0;
    };

    networking = {
      hostName = config.host;
      networkmanager.enable = true;

      firewall = {
        enable = true;
        # Enable multicast ports to discover local printers
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
        ];
      };

      nat = {
        enable = true;
        enableIPv6 = true;
      };
    };

    hardware = {
      # graphics = {
      #   enable = true;
      #   enable32Bit = true;
      # };

      framework.laptop13.audioEnhancement = {
        enable = true;
        rawDeviceName = "alsa_output.pci-0000_c1_00.6.analog-stere";
      };
      keyboard.qmk.enable = true;
      bluetooth.enable = true;
      bluetooth.powerOnBoot = true;
    };

    time.timeZone = "America/Detroit";

    services = {
      fwupd.enable = true;

      xserver = {
        enable = true;
        xkb.layout = "us";
        xkb.variant = "";
      };

      displayManager.sddm.enable = true;
      desktopManager.plasma6.enable = true;
      displayManager.sddm.wayland.enable = true;
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
      adb.enable = true;
      appimage = {
        enable = true;
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
      kdePackages.plymouth-kcm
      darkly
      nur.repos.shadowrz.klassy-qt6
      qalculate-qt
      aspell
      aspellDicts.en
      aspellDicts.en-computers
      aspellDicts.en-science
    ];

    system.stateVersion = "24.11";
  };
}
