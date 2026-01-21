{
  inputs,
  lib,
  ...
}: {
  flake-file.inputs = {
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };
  flake.aspects.ide = let
    makeHomeConfig = pkgs: {
      home.packages = with pkgs; [
        vscode
        code-cursor
        nixd
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
  in {
    homeManager = {pkgs, ...}: makeHomeConfig pkgs;
  };
}
