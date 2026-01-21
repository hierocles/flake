_: {
  flake.aspects.nom = let
    makeConfig = pkgs: {
      environment.systemPackages = [pkgs.nix-output-monitor];
    };
  in {
    nixos = {pkgs, ...}: makeConfig pkgs;
    darwin = {pkgs, ...}: makeConfig pkgs;
  };
}
