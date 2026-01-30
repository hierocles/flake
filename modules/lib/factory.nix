{
  inputs,
  lib,
  ...
}: {
  options.flake.lib = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = {};
  };

  config.flake.lib = {
    mkNixos = system: name: {
      ${name} = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          inputs.self.modules.nixos.${name}
          {
            nixpkgs.hostPlatform = lib.mkDefault system;
            nixpkgs.config.allowUnfree = lib.mkDefault true;
          }
        ];
      };
    };

    mkDarwin = system: name: {
      ${name} = inputs.nix-darwin.lib.darwinSystem {
        modules = [
          inputs.self.modules.darwin.${name}
          {
            nixpkgs.hostPlatform = lib.mkDefault system;
            nixpkgs.config.allowUnfree = lib.mkDefault true;
          }
        ];
      };
    };

    mkHomeManager = system: name: {
      ${name} = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        modules = [
          inputs.self.modules.homeManager.${name}
        ];
      };
    };

    # Build ISO image from a NixOS configuration
    # Usage: nix build .#packages.x86_64-linux.iso
    mkIsoImage = system: name:
      (inputs.self.lib.mkNixos system name).${name}.config.system.build.isoImage;
  };
}
