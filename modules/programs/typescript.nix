_: {
  flake.aspects.typescript = let
    makeHomeConfig = pkgs: {
      home.packages = with pkgs; [
        nodePackages.typescript
        nodePackages.typescript-language-server
      ];
    };
  in {
    homeManager = {pkgs, ...}: makeHomeConfig pkgs;
  };
}
