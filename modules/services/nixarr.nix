{
  inputs,
  lib,
  ...
}: {
  flake-file.inputs = {
    # Jellyfin hash mismatch fixed locally, need to submit PR
    nixarr.url = "path:/home/dylan/nixarr";
  };

  flake.aspects.nixarr = {
    nixos = {
      pkgs,
      config,
      ...
    }: {
      imports = lib.optionals (inputs ? nixarr) [inputs.nixarr.nixosModules.default];

      nixarr = {
        enable = true;
        mediaDir = "/mnt/media";
        stateDir = "/var/lib/nixarr/state";

        vpn = {
          enable = true;
          accessibleFrom = [
            inputs.secrets.networking.subnets.lan.mask
            "127.0.0.1"
          ];
          wgConf = config.sops.secrets."vpn/wgconf".path;
          vpnTestService = {
            enable = true;
            port = inputs.secrets.networking.vpn.port;
          };
        };

        autobrr.enable = true;
        bazarr.enable = true;
        radarr.enable = true;
        # Need to override sqlite package until v5 stable is released
        # See: https://github.com/Sonarr/Sonarr/issues/8249#issuecomment-3649898919
        sonarr = let
          sqlite-3-50 = pkgs.sqlite.overrideAttrs (old: {
            version = "3.50.0";
            src = pkgs.fetchurl {
              url = "https://sqlite.org/2025/sqlite-autoconf-3500000.tar.gz";
              sha256 = "09w32b04wbh1d5zmriwla7a02r93nd6vf3xqycap92a3yajpdirv";
            };
          });
        in {
          enable = true;
          package = pkgs.sonarr.override {sqlite = sqlite-3-50;};
        };
        prowlarr.enable = true;
        plex.enable = true;
        jellyseerr.enable = true;
        recyclarr = {
          enable = true;
          configFile = ./recyclarr.yaml;
        };
        qbittorrent = {
          enable = true;
          vpn.enable = true;
          qui.enable = true;
          privateTrackers.disableDhtPex = true;
        };

        # Temp enable in order to transfer torrents to qbt
        transmission = {
          enable = true;
          peerPort = inputs.secrets.networking.vpn.port;
          flood.enable = true;
          vpn.enable = true;
        };
      };

      services.flaresolverr.enable = true;
      # systemd.services.plex = {
      #   serviceConfig = {
      #     ReadWritePaths = ["/var/lib/plex-transcode"];
      #     PrivateTmp = lib.mkForce false;
      #     MemoryDenyWriteExecute = lib.mkForce false;
      #   };
      #   preStart = lib.mkAfter ''
      #     # Ensure transcode directory exists and is writable
      #     mkdir -p /var/lib/plex-transcode
      #     chown plex:media /var/lib/plex-transcode

      #     # Ensure EasyAudioEncoder is executable after codec updates
      #     find /var/lib/nixarr/state/plex/Plex\ Media\ Server/Codecs -name "EasyAudioEncoder" -type f -exec chmod +x {} \;
      #   '';
      # };
    };
  };
}
