{...}: {
  flake.aspects.react = let
    makeHomeConfig = pkgs: {
      home.packages = with pkgs; [
        vite
        tailwindcss
      ];
    };
  in {
    homeManager = {pkgs, ...}: makeHomeConfig pkgs;
  };
}
