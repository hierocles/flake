# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  outputs = inputs: inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules);

  inputs = {
    brew-api = {
      flake = false;
      url = "github:BatteredBunny/brew-api";
    };
    brew-nix = {
      inputs = {
        brew-api.follows = "brew-api";
        nix-darwin.follows = "nix-darwin";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:BatteredBunny/brew-nix";
    };
    deploy-rs = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:serokell/deploy-rs";
    };
    determinate = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
    };
    direnv-instant.url = "github:Mic92/direnv-instant";
    disko = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/disko";
    };
    flake-aspects.url = "github:vic/flake-aspects";
    flake-file.url = "github:vic/flake-file";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/master";
    };
    import-tree.url = "github:vic/import-tree";
    llm-agents.url = "github:numtide/llm-agents.nix";
    nix-darwin = {
      inputs.nixpkgs.follows = "nixpkgs-darwin";
      url = "github:LnL7/nix-darwin";
    };
    nix-mineral.url = "github:cynicsketch/nix-mineral";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix4nvchad = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nix4nvchad";
    };
    nixarr.url = "github:nix-media-server/nixarr/dev";
    nixos-anywhere = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nixos-anywhere";
    };
    nixos-cli.url = "github:nix-community/nixos-cli";
    nixos-wsl = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/NixOS-WSL";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-25.11-darwin";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    secrets.url = "git+ssh://git@github.com/hierocles/secrets.git?shallow=1";
    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Mic92/sops-nix";
    };
    treefmt-nix.url = "github:numtide/treefmt-nix";
    vscode-server.url = "github:Hyffer/nixos-vscode-server/fix-vsce-sign";
  };
}
