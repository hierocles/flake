{pkgs, ...}: {
  flake.aspects.nom = let
    package = {
      environment.systemPackages = [pkgs.nix-output-monitor];
    };
  in {
    nixos = package;
    darwin = package;
  };
}
