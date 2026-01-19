{
  inputs,
  lib,
  ...
}: {
  # Disabled: treefmt-nix input removed
  # flake-file.inputs = {
  #   treefmt-nix = {
  #     url = "github:numtide/treefmt-nix";
  #     inputs.nixpkgs.follows = "nixpkgs";
  #   };
  # };

  # imports = lib.optionals (inputs ? treefmt-nix) [inputs.treefmt-nix.flakeModule];

  flake.aspects.treefmt = let
    treefmt-nix = {
      treefmt = {
        programs = {
          alejandra.enable = true;
          prettier.enable = true;
          ruff.enable = true;
          eslint.enable = true;
          black.enable = true;
          deadnix.enable = true;
          statix.enable = true;
        };
        settings.on-unmatched = "warn";
      };
    };
  in {
    nixos = treefmt-nix;
    darwin = treefmt-nix;
  };
}
