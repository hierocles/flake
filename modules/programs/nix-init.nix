{self, ...}: {
  flake.aspects.nix-init = {
    homeManager = {pkgs, ...}: let
      flake = "(builtins.getFlake \"${self}\")";
    in {
      programs.nix-init = {
        enable = true;
        settings = {
          maintainers = ["hierocles"];
          nixpkgs = "${flake}.inputs.nixpkgs";
          format.command = ["${pkgs.alejandra}/bin/alejandra"];
        };
      };
    };
  };
}
