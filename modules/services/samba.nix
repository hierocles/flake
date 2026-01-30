{inputs, ...}: {
  flake.aspects.samba = {
    nixos = {
      pkgs,
      lib,
      config,
      ...
    }: {
      options.services.samba.customShares.media.validUsers = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Users allowed to access the media share";
      };

      config = {
        services.samba = {
          package = lib.mkDefault pkgs.samba4Full;
          usershares.enable = lib.mkDefault true;
          enable = lib.mkDefault true;
          openFirewall = lib.mkDefault true;
          settings = {
            global = {
              "workgroup" = "WORKGROUP";
              "server string" = "smbnix";
              "netbios name" = "smbnix";
              "security" = "user";
              "hosts allow" = "127.0.0.1 localhost ${inputs.secrets.networking.subnets.lan.prefix}";
              "hosts deny" = "0.0.0.0/0";
              "guest account" = "nobody";
              "map to guest" = "never";
            };
            "media" = {
              "path" = "/mnt/media";
              "browseable" = "yes";
              "read only" = "no";
              "guest ok" = "no";
              "create mask" = "0644";
              "directory mask" = "0755";
              "valid users" = lib.concatStringsSep " " config.services.samba.customShares.media.validUsers;
            };
          };
        };
        services.samba-wsdd = {
          enable = true;
          openFirewall = true;
        };
        services.avahi = {
          publish = {
            enable = true;
            userServices = true;
          };
          nssmdns4 = true;
          enable = true;
          openFirewall = true;
        };
      };
    };
  };
}
