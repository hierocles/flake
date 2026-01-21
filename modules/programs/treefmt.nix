{
  inputs,
  lib,
  ...
}:
{
  flake-file.inputs = {
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
    };
  };

  imports = lib.optionals (inputs ? treefmt-nix) [
    inputs.treefmt-nix.flakeModule
  ];

  # Empty aspect - treefmt is configured via perSystem
  flake.aspects.treefmt = {};
}
// lib.optionalAttrs (inputs ? treefmt-nix) {
  perSystem = {
    treefmt = {
      projectRootFile = "flake.nix";
      settings = {
        on-unmatched = "info";
      };
      programs = {
        # Nix
        alejandra.enable = true;
        deadnix.enable = true;
        statix.enable = true;
        # JS/TS/JSON/YAML/MD
        prettier.enable = true;
        # Python
        ruff-format.enable = true;
        ruff-check.enable = true;
        black.enable = true;
      };
    };
  };
}
