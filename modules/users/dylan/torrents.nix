_: {
  flake.aspects.dylan._.ttq = {
    homeManager = {inputs, ...}: {
      programs.transmission-to-qbittorrent = let
        serverIp = inputs.secrets.networking.server.ip;
      in {
        enable = true;

        transmission = {
          host = serverIp;
          port = inputs.secrets.networking.ports.transmission;
          #user = "admin";
          #passwordFile = /path/to/transmission-password;
        };

        qbittorrent = {
          host = serverIp;
          port = inputs.secrets.networking.ports.qbittorrent;
          #user = "admin";
          #passwordFile = /path/to/qbittorrent-password;
        };
      };
    };
  };
}
