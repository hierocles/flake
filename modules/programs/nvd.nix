{...}: {
  flake.aspects.nvd = let
    makeConfig = pkgs: {
      environment.systemPackages = [pkgs.nvd];
    };
  in {
    nixos = {pkgs, ...}: makeConfig pkgs;
    darwin = {pkgs, ...}: makeConfig pkgs;
  };
}
