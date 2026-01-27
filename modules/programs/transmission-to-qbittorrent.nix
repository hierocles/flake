{inputs, ...}: {
  flake.aspects.transmission-to-qbittorrent = {
    nixos.nixpkgs.overlays = [inputs.self.overlays.default];
    darwin.nixpkgs.overlays = [inputs.self.overlays.default];

    homeManager = {
      config,
      lib,
      pkgs,
      ...
    }: let
      cfg = config.programs.transmission-to-qbittorrent;

      wrappedScript = pkgs.writeShellScriptBin "transmission-to-qbittorrent" ''
        exec ${pkgs.transmission-to-qbittorrent}/bin/transmission-to-qbittorrent \
          --transmission-host ${lib.escapeShellArg cfg.transmission.host} \
          --transmission-port ${toString cfg.transmission.port} \
          ${lib.optionalString (cfg.transmission.user != null) "--transmission-user ${lib.escapeShellArg cfg.transmission.user}"} \
          ${lib.optionalString (cfg.transmission.passwordFile != null) "--transmission-pass \"$(cat ${lib.escapeShellArg cfg.transmission.passwordFile})\""} \
          --qbittorrent-host ${lib.escapeShellArg cfg.qbittorrent.host} \
          --qbittorrent-port ${toString cfg.qbittorrent.port} \
          ${lib.optionalString (cfg.qbittorrent.user != null) "--qbittorrent-user ${lib.escapeShellArg cfg.qbittorrent.user}"} \
          ${lib.optionalString (cfg.qbittorrent.passwordFile != null) "--qbittorrent-pass \"$(cat ${lib.escapeShellArg cfg.qbittorrent.passwordFile})\""} \
          "$@"
      '';
    in {
      options.programs.transmission-to-qbittorrent = {
        enable = lib.mkEnableOption "transmission-to-qbittorrent migration tool";

        transmission = {
          host = lib.mkOption {
            type = lib.types.str;
            description = "Transmission RPC host";
          };
          port = lib.mkOption {
            type = lib.types.port;
            description = "Transmission RPC port";
          };
          user = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Transmission RPC username (optional if auth disabled)";
          };
          passwordFile = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
            description = "Path to file containing Transmission RPC password";
          };
        };

        qbittorrent = {
          host = lib.mkOption {
            type = lib.types.str;
            description = "qBittorrent WebUI host";
          };
          port = lib.mkOption {
            type = lib.types.port;
            description = "qBittorrent WebUI port";
          };
          user = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "qBittorrent WebUI username (optional if auth disabled)";
          };
          passwordFile = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
            description = "Path to file containing qBittorrent WebUI password";
          };
        };
      };

      config = lib.mkIf cfg.enable {
        assertions = [
          {
            assertion = cfg.transmission.user == null || cfg.transmission.passwordFile != null;
            message = "programs.transmission-to-qbittorrent.transmission.passwordFile is required when transmission.user is set";
          }
          {
            assertion = cfg.qbittorrent.user == null || cfg.qbittorrent.passwordFile != null;
            message = "programs.transmission-to-qbittorrent.qbittorrent.passwordFile is required when qbittorrent.user is set";
          }
        ];

        home.packages = [wrappedScript];
      };
    };
  };
}
