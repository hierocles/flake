_: {
  flake.aspects.dylan._.samba = {
    nixos = {
      config,
      lib,
      ...
    }: {
      services.samba.customShares.media.validUsers = lib.mkIf config.services.samba.enable ["dylan"];

      system.activationScripts = lib.mkIf config.services.samba.enable {
        init_smbpasswd.text = ''
          /run/current-system/sw/bin/printf "$(/run/current-system/sw/bin/cat ${config.sops.secrets.passwords.dylan.path})\n$(/run/current-system/sw/bin/cat ${config.sops.secrets.passwords.dylan.path})\n" | /run/current-system/sw/bin/smbpasswd -sa dylan
        '';
      };
    };
  };
}
