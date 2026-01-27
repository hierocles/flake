_: {
  perSystem = {pkgs, ...}: {
    packages = {
      tqm = pkgs.callPackage ../../packages/tqm {};
      transmission-to-qbittorrent = pkgs.callPackage ../../packages/transmission-to-qbittorrent {};
    };
  };

  flake.overlays.default = _final: _prev: {
    tqm = _final.callPackage ../../packages/tqm {};
    transmission-to-qbittorrent = _final.callPackage ../../packages/transmission-to-qbittorrent {};
  };
}
