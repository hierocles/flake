{...}: {
  flake.aspects.bun = let
    makeConfig = pkgs: {
      environment.systemPackages = with pkgs; [
        bun
      ];
    };
  in {
    nixos = {pkgs, ...}: makeConfig pkgs;
    darwin = {pkgs, ...}: makeConfig pkgs;
  };
}
