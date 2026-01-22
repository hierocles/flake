{
  inputs,
  lib,
  ...
}: {
  flake-file.inputs = {
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.aspects = {aspects, ...}: {
    wsl = {
      description = "Use WSL for development on Windows";
      includes = with aspects; [
        wsl-essentials
        dylan
      ];
      nixos = {
        imports = lib.optionals (inputs ? nixos-wsl) [inputs.nixos-wsl.nixosModules.wsl];
        wsl = {
          enable = true;
          defaultUser = lib.mkDefault "dylan";
          startMenuLaunchers = true;
          wslConf.automount.root = "/mnt";
        };
        # WSL doesn't need a traditional bootloader or boot partition
        boot.loader.grub.enable = lib.mkForce false;
        boot.loader.systemd-boot.enable = lib.mkForce false;

        # Enable D-Bus for systemd user sessions (fixes Home Manager activation errors)
        services.dbus.enable = true;
        # Enable user lingering so systemd user services start at boot
        users.users.dylan.linger = true;
        # Connect transposed homeManager configs to the user
        home-manager.users.dylan.imports = [
          inputs.self.modules.homeManager.constants
          inputs.self.modules.homeManager.dylan
        ];
      };
    };
  };

  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "wsl";
}
