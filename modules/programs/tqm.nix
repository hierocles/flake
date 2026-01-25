{inputs, ...}: {
  flake.aspects.tqm = {
    nixos.nixpkgs.overlays = [inputs.self.overlays.default];
    homeManager = {pkgs, ...}: {
      home.packages = [pkgs.tqm];
    };
  };
}
