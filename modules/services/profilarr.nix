{inputs, ...}: {
  flake.aspects.profilarr = {
    nixos = {
      config,
      lib,
      pkgs,
      ...
    }: let
      cfg = config.services.profilarr;
    in {
      options.services.profilarr = {
        enable = lib.mkEnableOption "Profilarr configuration management for Radarr/Sonarr";

        port = lib.mkOption {
          type = lib.types.port;
          default = 8000;
          description = "Port to listen on";
        };

        dataDir = lib.mkOption {
          type = lib.types.path;
          default = "/var/lib/profilarr";
          description = "Directory for Profilarr data and configuration";
        };

        user = lib.mkOption {
          type = lib.types.str;
          default = "profilarr";
          description = "User to run Profilarr as";
        };

        group = lib.mkOption {
          type = lib.types.str;
          default = "profilarr";
          description = "Group to run Profilarr as";
        };

        openFirewall = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether to open the firewall for the Profilarr port";
        };
      };

      config = lib.mkMerge [
        {
          nixpkgs.overlays = [inputs.self.overlays.default];
        }
        (lib.mkIf cfg.enable {
          users.users.${cfg.user} = {
            isSystemUser = true;
            group = cfg.group;
            home = cfg.dataDir;
            createHome = true;
          };

          users.groups.${cfg.group} = {};

          systemd.services.profilarr = {
            description = "Profilarr - Configuration Management for Radarr/Sonarr";
            wantedBy = ["multi-user.target"];
            after = ["network.target"];

            environment = {
              APP_BASE_PATH = cfg.dataDir;
              PORT = toString cfg.port;
            };

            serviceConfig = {
              Type = "simple";
              User = cfg.user;
              Group = cfg.group;
              ExecStart = "${pkgs.profilarr}/bin/profilarr";
              Restart = "on-failure";
              RestartSec = 5;

              StateDirectory = "profilarr";
              StateDirectoryMode = "0750";
              WorkingDirectory = cfg.dataDir;

              # Hardening
              NoNewPrivileges = true;
              ProtectSystem = "strict";
              ProtectHome = true;
              PrivateTmp = true;
              PrivateDevices = true;
              ProtectKernelTunables = true;
              ProtectKernelModules = true;
              ProtectControlGroups = true;
              RestrictNamespaces = true;
              RestrictSUIDSGID = true;
              MemoryDenyWriteExecute = false; # Deno may need this
              ReadWritePaths = [cfg.dataDir];
            };
          };

          networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [cfg.port];
        })
      ];
    };
  };
}
