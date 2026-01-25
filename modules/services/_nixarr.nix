{
  inputs,
  lib,
  ...
}: {
  flake-file.inputs = {
    nixarr.url = "github:nix-media-server/nixarr/dev";
  };

  flake.aspects.nixarr = {
    nixos = {
      imports = lib.optionals (inputs ? nixarr) [inputs.nixarr.nixosModules.default];

      nixarr = {
        enable = true;
        mediaDir = "/mnt/media";
        stateDir = "/var/lib/nixarr/state";

        vpn = {};

        autobrr.enable = true;
        bazarr.enable = true;
        radarr.enable = true;
        sonarr.enable = true;
        prowlarr.enable = true;
        plex.enable = true;
        jellyseerr.enable = true;
        recyclarr = {
          enable = true;
          configFile = ./recyclarr.yaml;
        };
        qbittorrent = {
          enable = true;
          openFirewall = true;
          vpn.enable = true;
          qui.enable = true;
        };
      };

      services.flaresolverr.enable = true;
      systemd.services.plex = {
        serviceConfig = {
          ReadWritePaths = ["/var/lib/plex-transcode"];
          PrivateTmp = lib.mkForce false;
          MemoryDenyWriteExecute = lib.mkForce false;
        };
        preStart = lib.mkAfter ''
          # Ensure transcode directory exists and is writable
          mkdir -p /var/lib/plex-transcode
          chown plex:media /var/lib/plex-transcode

          # Ensure EasyAudioEncoder is executable after codec updates
          find /var/lib/nixarr/state/plex/Plex\ Media\ Server/Codecs -name "EasyAudioEncoder" -type f -exec chmod +x {} \;
        '';
      };
    };
  };
}
