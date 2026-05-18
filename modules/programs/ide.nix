{
  inputs,
  lib,
  ...
}: {
  flake-file.inputs = {
    cursor-server.url = "github:KINGFIOX/nixos-cursor-server";
  };
  flake.aspects.ide = {
    nixos = {pkgs, ...}: {
      imports = lib.optionals (inputs ? cursor-server) [
        inputs.cursor-server.nixosModules.default
      ];
      services.cursor-server = {
        enable = true;
        nodejsPackage = pkgs.nodejs_22;
      };
    };
    darwin = {};
    homeManager = {};
  };
}
