{
  flake.aspects = {aspects, ...}: {
    server-essentials = {
      description = "Essential system configuration for headless servers";
      includes = with aspects; [
        system-defaults
        constants
        home-manager
        secrets
        ssh
        determinate
        # Exclude: fonts (no display)
        # Exclude: mineral (desktop boot config)
        # Exclude: homebrew (macOS specific)
      ];
      nixos = {lib, ...}: {
        # Disable GUI-related services
        services.xserver.enable = lib.mkDefault false;
        #environment.noXlibs = lib.mkDefault true;

        # Disable sound
        services.pulseaudio.enable = lib.mkDefault false;
        services.pipewire.enable = lib.mkDefault false;

        # Enable headless mode
        boot.plymouth.enable = lib.mkDefault false;

        # Common server utilities
        programs.mtr.enable = true;
        programs.iftop.enable = true;
      };
      darwin = {};
      homeManager = {};
    };
  };
}
