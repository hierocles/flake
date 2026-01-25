_: {
  perSystem = {pkgs, ...}: {
    packages = {
      tqm = pkgs.callPackage ../../packages/tqm {};
    };
  };

  flake.overlays.default = _final: _prev: {
    tqm = _final.callPackage ../../packages/tqm {};
  };
}
