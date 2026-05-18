{
  inputs,
  lib,
  ...
}: {
  flake-file.inputs = {
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };
  flake.aspects.ide = {
    nixos = {pkgs, ...}: {
      imports = lib.optionals (inputs ? vscode-server) [
        inputs.vscode-server.nixosModules.default
      ];
      services.vscode-server = {
        enable = true;
        nodejsPackage = pkgs.nodejs_22; # LTS version, avoids Copilot compatibility issues with Node 25
      };
    };
  };
}
