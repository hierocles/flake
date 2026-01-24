{
  inputs,
  lib,
  ...
}: {
  flake-file.inputs = {
    #vscode-server.url = "github:nix-community/nixos-vscode-server";
    vscode-server.url = "github:Hyffer/nixos-vscode-server/fix-vsce-sign";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };
  flake.aspects.ide = {
    nixos = {pkgs, ...}: {
      imports = lib.optionals (inputs ? vscode-server) [
        inputs.vscode-server.nixosModules.default
      ];
      nixpkgs.overlays = lib.optionals (inputs ? nix-vscode-extensions) [inputs.nix-vscode-extensions.overlays.default];
      # Prevent WSL prompt when home-manager runs 'code' command during activation
      environment.variables.DONT_PROMPT_WSL_INSTALL = "1";
      services.vscode-server = {
        enable = true;
        nodejsPackage = pkgs.nodejs_22; # LTS version, avoids Copilot compatibility issues with Node 25
      };
    };
    darwin.nixpkgs.overlays = lib.optionals (inputs ? nix-vscode-extensions) [inputs.nix-vscode-extensions.overlays.default];
    homeManager = {
      programs.vscode = {
        enable = true;
      };
    };
  };
}
