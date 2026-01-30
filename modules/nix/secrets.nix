{
  inputs,
  lib,
  ...
}: {
  flake-file.inputs = {
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    secrets = {
      url = "git+ssh://git@github.com/hierocles/secrets.git";
    };
  };

  flake.aspects.secrets = {
    description = "Sops-nix secrets management";
    nixos.imports = lib.optionals (inputs ? sops-nix) [inputs.sops-nix.nixosModules.sops];
    darwin.imports = lib.optionals (inputs ? sops-nix) [inputs.sops-nix.darwinModules.sops];
    homeManager.imports = lib.optionals (inputs ? sops-nix) [inputs.sops-nix.homeManagerModules.sops];
  };
}
