_: {
  perSystem = {pkgs, ...}: {
    packages = {
      #profilarr = pkgs.callPackage ../../packages/profilarr {};
      tqm = pkgs.callPackage ../../packages/tqm {};
      transmission-to-qbittorrent = pkgs.callPackage ../../packages/transmission-to-qbittorrent {};
    };
  };

  flake.overlays.default = _final: _prev: {
    profilarr = _final.callPackage ../../packages/profilarr {};
    tqm = _final.callPackage ../../packages/tqm {};
    transmission-to-qbittorrent = _final.callPackage ../../packages/transmission-to-qbittorrent {};
  };
}
