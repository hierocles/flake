{pkgs, ...}: {
  flake.aspects.nom = let
    package = {
      sytem.environmentPackages = [pkgs.nix-output-monitor];
    };
  in {
    nixos = package;
    darwin = package;
  };
}
