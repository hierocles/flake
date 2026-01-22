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
      nixos = {pkgs, ...}: {
        programs.nix-ld = {
          enable = true;
          libraries = with pkgs; [
            # Core libraries for dynamically linked binaries
            stdenv.cc.cc.lib
            zlib
            openssl
            curl
            icu
            # Additional libraries commonly needed by VS Code extensions
            libsecret
            libGL
            glib
          ];
        };
      };
      darwin = {};
      homeManager = {};
    };
  };
}
