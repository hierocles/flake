{inputs, ...}: {
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
          nvchad = inputs.nix4nvchad.packages."${prev.stdenv.hostPlatform.system}".nvchad;
        })
      ];
    };
    makeHomeConfig = pkgs: {
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
  in {
    nixos = overlay;
    darwin = overlay;
    homeManager = {pkgs, ...}: makeHomeConfig pkgs;
  };
}
