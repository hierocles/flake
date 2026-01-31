_: {
  flake.aspects.dylan._.samba = {
    nixos = {
      config,
      lib,
      pkgs,
      ...
    }: {
      services.samba.customShares.media.validUsers = lib.mkIf config.services.samba.enable ["dylan"];

      system.activationScripts = lib.mkIf config.services.samba.enable {
        init_smbpasswd.text = ''
          printf "$(<${config.sops.secrets."passwords/dylan".path})\n$(<${config.sops.secrets."passwords/dylan".path})\n" | ${pkgs.samba}/bin/smbpasswd -sa dylan
        '';
      };
    };
  };
}
