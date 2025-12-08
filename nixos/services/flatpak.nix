{
  services.flatpak = {
    enable = true;

    overrides = {
      global.Environment = {
        GTK_THEME = "Adwaita:dark";
      };
    };
    remotes = [
      {
        name = "flathub";
        location = "https://flathub.org/repo/flathub.flatpakrepo";
      }
    ];
    packages = [
      "one.ablaze.floorp"
      "moe.launcher.an-anime-game-launcher"
      "moe.launcher.the-honkers-railway-launcher"
      "org.gnome.Platform//45"
      "com.usebottles.bottles"
      "io.mrarm.mcpelauncher"
      "io.mango3d.LycheeSlicer"
    ];
  };
}
