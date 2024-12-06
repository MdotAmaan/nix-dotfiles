final: prev: 
{
  renderdoc = prev.renderdoc.overrideAttrs (old: {
    version = "1.31";
    src = prev.fetchFromGitHub {
      owner = "baldurk";
      repo = "renderdoc";
      rev = "04bfedcdd56db79ef78b738d3c0729f0bdcb0b04";
      sha256 = "1d4q4rln0ml15sm0387q2vaw4rlnn2xcd9s87k29343z43cjamab";
    };
  });
}
