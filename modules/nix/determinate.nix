{
  inputs,
  lib,
  ...
}: let
  commonSubstituters = [
    "https://cache.nixos.org?priority=10"
    "https://install.determinate.systems"
    "https://nix-community.cachix.org"
    "https://cache.numtide.com"
  ];

  commonTrustedPublicKeys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM"
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
  ];

  commonExperimentalFeatures = [
    "nix-command"
    "flakes"
  ];

  commonSettings = {
    warn-dirty = false;
    experimental-features = commonExperimentalFeatures;
    substituters = commonSubstituters;
    trusted-public-keys = commonTrustedPublicKeys;
  };
in {
  flake-file.inputs = {
    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.aspects.determinate = {
    description = "Use Determinate Nix 3";
    nixos = {
      imports = lib.optionals (inputs ? determinate) [inputs.determinate.nixosModules.default];
      nix.enable = false;
      determinate.nix.settings =
        commonSettings
        // {
          extra-substituters = [
            "https://watersucks.cachix.org"
          ];
          extra-trusted-public-keys = [
            "watersucks.cachix.org-1:6gadPC5R8iLWQ3EUtfu3GFrVY7X6I4Fwz/ihW25Jbv8="
          ];
          download-buffer-size = 1024 * 1024 * 1024;
          keep-outputs = true;
          trusted-users = [
            "root"
            "@wheel"
          ];
        };
    };
    darwin = {
      imports = lib.optionals (inputs ? determinate) [inputs.determinate.darwinModules.default];
      nix.enable = false;
      determinate.nix.settings =
        commonSettings
        // {
          eval-cores = 0;
          flake-registry = "";
          lazy-trees = true;
          extra-experimental-features = [
            "build-time-fetch-tree"
            "parallel-eval"
          ];
        };
    };
  };
}
