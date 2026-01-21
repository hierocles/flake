_: {
  # Empty aspect - devShell is configured via perSystem
  flake.aspects.devshell = {};

  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShell {
      packages = with pkgs; [
        # Nix tools
        statix
        alejandra
        deadnix
        nixd

        # Formatters
        prettier
        ruff
        black
      ];
    };
  };
}
