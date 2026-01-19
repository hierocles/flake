{inputs, pkgs, ...}: {
  flake-file.inputs = {
    nix-init.url = "github:nix-community/nix-init";
  };

  flake.aspects.cli.nix-init = {
    environment.systemPackages = [
      inputs.nix-init.packages.${pkgs.stdenv.hostPlatform.system}.nix-init
    ];
    nix-init.enable = true;
  };
}
