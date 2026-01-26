{inputs, ...}: {
  flake.aspects = {aspects, ...}: {
    server = {
      description = "Home server";
      includes = with aspects; [
        system-essentials
        bootloader
        disko
        dylan
        nixarr
        server._.disks
        server._.hardware
        server._.secrets
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
      };
    };
  };

  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "server";
}
