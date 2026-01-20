{
  flake.aspects = {aspects, ...}: {
    wsl-essentials = {
      description = "Essential system configuration for WSL";
      includes = with aspects; [
        system-defaults
        constants
        home-manager
        secrets
        fonts
        # Exclude: mineral (may set boot config)
        # Exclude: determinate (macOS specific)
        # Exclude: homebrew (macOS specific)
      ];
      nixos = {
        programs.nix-ld.enable = true;
      };
      darwin = {};
      homeManager = {};
    };
  };
}
