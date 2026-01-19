{
  inputs,
  lib,
  ...
}: {
  flake-file.inputs = {
    nix-mineral.url = "github:cynicsketch/nix-mineral";
  };

  flake.aspects.mineral.nixos = {
    imports = lib.optionals (inputs ? nix-mineral) [inputs.nix-mineral.nixosModules.nix-mineral];
    nix-mineral = {
      enable = true;
      preset = "compatibility";
    };
  };
}
