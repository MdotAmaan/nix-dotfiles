final: prev: {
  renderdoc = prev.renderdoc.overrideAttrs (oldAttrs: {
    version = "1.31";
    src = prev.fetchFromGitHub {
      owner = "baldurk";
      repo = "renderdoc";
      rev = "v1.31";
      sha256 = "1d4q4rln0ml15sm0387q2vaw4rlnn2xcd9s87k29343z43cjamab";
    };
  });
}
