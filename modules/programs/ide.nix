{
  inputs,
  lib,
  pkgs,
  ...
}: {
  flake-file.inputs = {
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };
  flake.aspects.ide = {
    homeManager = {
      home.packages = with pkgs; [
        vscode
        code-cursor
      ];
      imports = lib.optionals (inputs ? vscode-server) [inputs.vscode-server.homeModules.default];
      services.vscode-server = {
        enable = true;
        nodejsPackage = pkgs.nodejs_latest;
        installPath = [
          "$HOME/.vscode-server"
          "$HOME/.cursor-server"
        ];
      };
    };
  };
}
