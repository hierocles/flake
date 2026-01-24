{
  inputs,
  lib,
  ...
}: {
  flake-file.inputs = {
    #vscode-server.url = "github:nix-community/nixos-vscode-server";
    vscode-server.url = "github:Hyffer/nixos-vscode-server/fix-vsce-sign";
    #vscode-remote-workaround.url = "github:K900/vscode-remote-workaround";
  };
  flake.aspects.ide = let
    makeNixosConfig = pkgs: {
      imports = lib.optionals (inputs ? vscode-server) [inputs.vscode-server.nixosModules.default];
      nixpkgs.overlays = lib.optionals (inputs ? self) [inputs.self.overlays.default];
      environment.systemPackages = with pkgs; [
        vscode
        nixd
        nodejs_latest
      ];
      services.vscode-server = {
        enable = true;
        nodejsPackage = pkgs.nodejs_latest;
      };
    };
  in {
    nixos = {pkgs, ...}: makeNixosConfig pkgs;
    darwin.nixpkgs.overlays = lib.optionals (inputs ? self) [inputs.self.overlays.default];
    homeManager = {};
  };
}
