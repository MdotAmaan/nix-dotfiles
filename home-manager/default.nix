{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./programs/plasma.nix
    ./programs/neovim.nix
    ./programs/firefox.nix
    ./programs/lf/lf.nix
  ];

  nixpkgs = {
    overlays = [
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      permittedInsecurePackages = [
        "electron-27.3.11"
      ];
    };
  };

  systemd.user.startServices = "sd-switch";
}
