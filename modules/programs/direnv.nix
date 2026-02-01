{
  flake-file.inputs = {
    direnv-instant.url = "github:Mic92/direnv-instant";
  };

  flake.aspects.direnv = {
    homeManager = {
      programs.direnv = {
        enable = true;
        silent = true;
        enableFishIntegration = true;
        nix-direnv.enable = true;
      };
      programs.direnv-instant = {
        enable = true;
        enableFishIntegration = true;
      };
    };
  };
}
