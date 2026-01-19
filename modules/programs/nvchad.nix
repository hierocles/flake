{
  inputs,
  pkgs,
  ...
}: {
  flake-file.inputs = {
    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.aspects.nvchad = let
    overlay = {
      nixpkgs.overlays = [
        (final: prev: {
          nvchad = inputs.nix4nvchad.packages."${pkgs.stdenv.hostPlatform.system}".nvchad;
        })
      ];
    };
  in {
    nixos = overlay;
    darwin = overlay;
    homeManager = {
      imports = [
        inputs.nix4nvchad.homeManagerModule
      ];

      programs.nvchad = {
        enable = true;
        hm-activation = true;
        backup = true;
        extraPackages = with pkgs; [
          nixd
          # Other packages
        ];
      };
    };
  };
}
