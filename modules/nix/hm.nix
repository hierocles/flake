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
  hm-extra-args = {
    home-manager.extraSpecialArgs = {
      inherit (inputs) self;
    };
  };
in {
  flake-file.inputs = {
    home-manager.url = "github:nix-community/home-manager/master";
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
        ++ [hm-config hm-extra-args];
      home-manager.sharedModules =
        lib.optionals (inputs ? direnv-instant) [inputs.direnv-instant.homeModules.direnv-instant];
    };
    nixos = {
      imports =
        lib.optionals (inputs ? home-manager) [inputs.home-manager.nixosModules.home-manager]
        ++ [hm-config hm-extra-args];
      home-manager.sharedModules =
        lib.optionals (inputs ? direnv-instant) [inputs.direnv-instant.homeModules.direnv-instant];
    };
  };
}
