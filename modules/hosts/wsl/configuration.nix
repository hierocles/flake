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
          wslConf = {
            automount.enabled = true;
            interop.appendWindowsPath = false;
            network.generateHosts = false;
          };
        };
        home-manager.users.dylan = {
          imports = [
            inputs.self.modules.homeManager.constants
            inputs.self.modules.homeManager.dylan
          ];
        };
        networking.hostName = "wsl";
      };
    };
  };

  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "wsl";
}
