{pkgs, ...}: {
  flake.aspects.python = let
    python = {
      environment.systemPackages = with pkgs; [
        python3
      ];
    };
  in {
    nixos = python;
    darwin = python;
    homeManager = {
      home.packages = with pkgs; [
        python3Packages.pip
        ruff
        black
      ];
    };
  };
}
