{
  lib,
  python3Packages,
}:
python3Packages.buildPythonApplication {
  pname = "transmission-to-qbittorrent";
  version = "0.1.0";

  src = ./.;
  format = "other";

  propagatedBuildInputs = with python3Packages; [
    requests
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp transmission_to_qbittorrent.py $out/bin/transmission-to-qbittorrent
    chmod +x $out/bin/transmission-to-qbittorrent
  '';

  meta = with lib; {
    description = "Export torrents from Transmission and add to qBittorrent via magnet links";
    license = licenses.mit;
    mainProgram = "transmission-to-qbittorrent";
    maintainers = [hierocles];
  };
}
