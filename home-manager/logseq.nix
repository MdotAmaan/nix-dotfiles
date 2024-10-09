{pkgs, ...}
final: prev: {
  logseq = prev.logseq.override {
      electron = pkgs.electron_27:
   };
};
