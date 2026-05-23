{inputs, ...}: {
  flake.aspects = {aspects, ...}: {
    server = {
      description = "Home server";
      includes = with aspects; [
        server-essentials
        bootloader
        disko
        dylan
        #dylan._.samba
        #samba
        nixarr
        #profilarr
        transmission-to-qbittorrent
        server._.disks
        server._.hardware
        server._.secrets
        server._.install-script
      ];
      nixos = {
        home-manager.users.dylan = {
          imports = [
            inputs.self.modules.homeManager.constants
            inputs.self.modules.homeManager.dylan
          ];
        };
        networking.hostName = "server";
        i18n.defaultLocale = "en_US.UTF-8";

        # Allow *Arr to hardlink files owned by other users
        boot.kernel.sysctl."fs.protected_hardlinks" = 0;

        # services.profilarr = {
        #   enable = true;
        #   openFirewall = true;
        #   port = 8912;
        # };
      };
    };
  };

  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "server";
}
