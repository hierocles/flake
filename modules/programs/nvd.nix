{pkgs, ...}: {
  flake.aspects.nvd = let
    package = {
      environment.systemPackages = [pkgs.nvd];
    };
  in {
    nixos = package;
    darwin = package;
  };
}
