{
  services.flatpak = {
    enable = true;

    remotes = [
      {
        name = "flathub";
        location = "https://flathub.org/repo/flathub.flatpakrepo";
      }
      {
        name = "launcher.moe";
        location = "https://gol.launcher.moe/gol.launcher.moe.flatpakrepo";
      }
    ];
    packages = [
      {
        appId = "moe.launcher.the-honkers-railway-launcher";
        origin = "launcher.moe";
      }
      {
        appId = "moe.launcher.an-anime-game-launcher";
        origin = "launcher.moe";
      }

      "org.gnome.Platform//45"
      "com.usebottles.bottles"
      "io.mrarm.mcpelauncher"
      "io.mango3d.LycheeSlicer"
    ];
  };
}
