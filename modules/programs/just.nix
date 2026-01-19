{pkgs, ...}: {
  flake.aspects.just = let
    package = {
      environment.systemPackages = [pkgs.just];
    };
  in {
    nixos = package;
    darwin = package;
  };
}
