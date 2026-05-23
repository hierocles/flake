{
  inputs,
  lib,
  ...
}: {
  flake-file.inputs = {
    nixarr.url = "github:nix-media-server/nixarr";
  };

  flake.aspects.nixarr = {
    nixos = {
      pkgs,
      config,
      lib,
      ...
    }: {
      imports = lib.optionals (inputs ? nixarr) [
        inputs.nixarr.nixosModules.default
      ];

      nixarr = {
        enable = true;
        mediaDir = "/mnt/media";
        stateDir = "/var/lib/nixarr/state";

        vpn = {
          enable = true;
          accessibleFrom = [
            inputs.secrets.networking.subnets.lan.mask
          ];
          wgConf = config.sops.secrets."vpn/wgconf".path;
          vpnTestService = {
            enable = true;
            port = inputs.secrets.networking.ports.vpn;
          };
        };

        #autobrr = {
        #  enable = true;
       #   openFirewall = true;
       # };
       # bazarr = {
       #   enable = true;
       #   openFirewall = true;
       # };
        radarr = {
          enable = true;
          openFirewall = true;
        };
        sonarr = {
          enable = true;
          openFirewall = true;
        };
        prowlarr = {
          enable = true;
          openFirewall = true;
        };
        plex = {
          enable = true;
          openFirewall = true;
        };
        seerr = {
          enable = true;
          openFirewall = true;
        };
        recyclarr = {
          enable = true;
          configFile = ./recyclarr.yaml;
        };
        qbittorrent = {
          enable = true;
          peerPort = inputs.secrets.networking.ports.vpn;
          openFirewall = true;
          vpn.enable = true;
          qui.enable = true;
          privateTrackers.disableDhtPex = true;
        };
      };

      # nixarr still invokes `recyclarr` with `--app-data`, removed in Recyclarr v8+.
      # Match `RECYCLARR_*` handling in nixpkgs `services.recyclarr`.
      systemd.services.recyclarr.serviceConfig = lib.mkIf (config.nixarr.enable && config.nixarr.recyclarr.enable) (
        let
          r = config.nixarr.recyclarr;
          # Same idea as nixarr's `recyclarr/default.nix` `effectiveConfigFile` (env_var tags).
          yamlGenerator = {preserved-tags ? []}: let
            selectors =
              pkgs.lib.strings.concatStringsSep "|"
              (builtins.map (
                  x: ''
                    with((.. | select(kind == "scalar") | select(tag == "!!str") | select(test("^!${x} .*"))); . = sub("!${x} ", "") | . tag="!${x}")
                  ''
                )
                preserved-tags);
          in {
            generate = name: value:
              pkgs.callPackage (
                {
                  runCommand,
                  yq-go,
                }:
                  runCommand name
                  {
                    nativeBuildInputs = [yq-go];
                    value = builtins.toJSON value;
                    passAsFile = ["value"];
                    preferLocalBuild = true;
                  }
                  ''
                    yq '${selectors}' "$valuePath" -o yaml > $out
                  ''
              ) {};
          };
          format = yamlGenerator {preserved-tags = ["env_var"];};
          generated = format.generate "recyclarr-config.yml" r.configuration;
          configPath =
            if r.configFile != null
            then r.configFile
            else generated;
        in {
          ExecStart = lib.mkOverride 9 "${lib.getExe r.package} ${config.services.recyclarr.command} --config ${configPath}";
          Environment = lib.mkOverride 9 [
            "RECYCLARR_CONFIG_DIR=${toString r.stateDir}"
            "RECYCLARR_DATA_DIR=${toString r.stateDir}"
          ];
        }
      );

      services.flaresolverr.enable = true;
    };
  };
}
