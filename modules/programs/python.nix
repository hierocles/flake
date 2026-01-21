_: {
  flake.aspects.python = let
    makeConfig = pkgs: {
      environment.systemPackages = with pkgs; [
        python3
      ];
    };
    makeHomeConfig = pkgs: {
      home.packages = with pkgs; [
        python3Packages.pip
        ruff
        black
      ];
    };
  in {
    nixos = {pkgs, ...}: makeConfig pkgs;
    darwin = {pkgs, ...}: makeConfig pkgs;
    homeManager = {pkgs, ...}: makeHomeConfig pkgs;
  };
}
