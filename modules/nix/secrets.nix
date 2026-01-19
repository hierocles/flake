{
  inputs,
  lib,
  ...
}: {
  flake-file.inputs = {
    agenix = {
      url = "github:yaxitech/ragenix"; # Drop-in Rust replacement for Agenix
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix-shell = {
      url = "github:aciceri/agenix-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    secrets = {
      url = "git+ssh://git@github.com/hierocles/secrets.git?shallow=1";
      flake = false;
    };
  };

  imports =
    lib.optionals (inputs ? agenix-rekey) [inputs.agenix-rekey.flakeModule]
    ++ lib.optionals (inputs ? agenix-shell) [inputs.agenix-shell.flakeModules.default];

  flake.aspects.secrets = {
    description = "Agenix secrets management";
    nixos = {pkgs, ...}: {
      imports = lib.optionals (inputs ? agenix) [inputs.agenix.nixosModules.default];
      environment.systemPackages = [
        inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
    darwin = {pkgs, ...}: {
      imports = lib.optionals (inputs ? agenix) [inputs.agenix.darwinModules.default];
      environment.systemPackages = [
        inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
    homeManager = {
      imports = lib.optionals (inputs ? agenix) [inputs.agenix.homeManagerModules.default];
    };
  };
}
