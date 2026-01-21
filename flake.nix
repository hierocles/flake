# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  outputs = inputs: inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules);

  inputs = {
    agenix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:yaxitech/ragenix";
    };
    agenix-rekey = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:oddlama/agenix-rekey";
    };
    agenix-shell = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:aciceri/agenix-shell";
    };
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
    determinate = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
    };
    direnv-instant.url = "github:Mic92/direnv-instant";
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
    nix-init.url = "github:nix-community/nix-init";
    nix-mineral.url = "github:cynicsketch/nix-mineral";
    nix4nvchad = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nix4nvchad";
    };
    nixos-cli.url = "github:nix-community/nixos-cli";
    nixos-wsl = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/NixOS-WSL";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-25.11-darwin";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    secrets = {
      flake = false;
      url = "git+ssh://git@github.com/hierocles/secrets.git?shallow=1";
    };
    treefmt-nix.url = "github:numtide/treefmt-nix";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };
}
