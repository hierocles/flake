{
  inputs,
  lib,
  ...
}: let
  hm-config = {
    home-manager = {
      verbose = true;
      useUserPackages = true;
      useGlobalPkgs = true;
      backupFileExtension = "backup";
      backupCommand = "rm";
      overwriteBackup = true;
    };
  };
in {
  flake-file.inputs = {
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  imports = lib.optionals (inputs ? home-manager) [
    inputs.home-manager.flakeModules.home-manager
  ];

  flake.aspects.home-manager = {
    description = "Use Home Manager";
    darwin = {
      imports =
        lib.optionals (inputs ? home-manager) [inputs.home-manager.darwinModules.home-manager]
        ++ [hm-config];
    };
    nixos = {
      imports =
        lib.optionals (inputs ? home-manager) [inputs.home-manager.nixosModules.home-manager]
        ++ [hm-config];
    };
  };
}
