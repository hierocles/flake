{...}: {
  flake.aspects.just = let
    makeConfig = pkgs: {
      environment.systemPackages = [pkgs.just];
    };
  in {
    nixos = {pkgs, ...}: makeConfig pkgs;
    darwin = {pkgs, ...}: makeConfig pkgs;
  };
}
