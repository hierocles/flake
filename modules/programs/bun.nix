{pkgs, ...}: {
  flake.aspects.bun = let
    bun-runtime = {
      environment.systemPackages = with pkgs; [
        bun
      ];
    };
  in {
    nixos = bun-runtime;
    darwin = bun-runtime;
  };
}
