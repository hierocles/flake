{inputs, ...}: {
  flake-file.inputs = {
    brew-nix = {
      url = "github:BatteredBunny/brew-nix";
      inputs.nix-darwin.follows = "nix-darwin";
      inputs.brew-api.follows = "brew-api";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    brew-api = {
      url = "github:BatteredBunny/brew-api";
      flake = false;
    };
  };

  flake.aspects.homebrew = {
    description = "Use Brew-Nix on macOS for Homebrew";
    darwin = {
      imports = [
        inputs.brew-nix.darwinModules.default
        {
          brew-nix.enable = true;
        }
      ];
    };
  };
}
