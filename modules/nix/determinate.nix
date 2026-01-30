{
  inputs,
  lib,
  ...
}: {
  flake-file.inputs = {
    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.aspects.determinate = {
    description = "Use Determinate Nix 3";
    nixos.imports = lib.optionals (inputs ? determinate) [inputs.determinate.nixosModules.default];
    darwin = {
      imports = lib.optionals (inputs ? determinate) [inputs.determinate.darwinModules.default];
      nix.enable = false;
    };
  };
}
