{
  inputs,
  lib,
  ...
}: {
  flake-file.inputs = {
    cursor-server = "github:KINGFIOX/nixos-cursor-server";
  };
  flake.aspects.ide = {
    nixos = {
      imports = lib.optionals (inputs ? cursor-server) [
        inputs.cursor-server.nixosModules.default
      ];
      cursor-server = {
        enable = true;
        nodejsPackage = pkgs.nodejs_22;
      };
    };
    darwin = {};
    homeManager = {};
  };
}
