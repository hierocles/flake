{pkgs, ...}: {
  flake.aspects.nvd = let
    package = {
      sytem.environmentPackages = [pkgs.nvd];
    };
  in {
    nixos = package;
    darwin = package;
  };
}
