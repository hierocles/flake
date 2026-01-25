_: {
  flake.aspects.secrets-management = let
    makeConfig = pkgs: {
      environment.systemPackages = [
        pkgs.sops
        pkgs.age
      ];
    };
  in {
    nixos = {pkgs, ...}: makeConfig pkgs;
    darwin = {pkgs, ...}: makeConfig pkgs;
  };
}
