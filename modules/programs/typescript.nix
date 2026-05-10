_: {
  flake.aspects.typescript = let
    makeHomeConfig = pkgs: {
      home.packages = with pkgs; [
        typescript
        typescript-language-server
      ];
    };
  in {
    homeManager = {pkgs, ...}: makeHomeConfig pkgs;
  };
}
