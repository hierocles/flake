{
  inputs,
  lib,
  ...
}: {
  flake-file.inputs.disko = {
    url = "github:nix-community/disko";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.aspects.disko = {
    nixos.imports = lib.optionals (inputs ? disko) [inputs.disko.nixosModules.disko];
  };
}
