{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    xournalpp
  ];

  home.file."${config.home.homeDirectory}/.config/xournalpp/plugins/vi-xournalpp/" = {
    enable = true;
    recursive = true;
    source = config.lib.file.mkOutOfStoreSymlink ./vi-xournalpp;
  };
}
