{
  flake.aspects = {aspects, ...}: {
    system-essentials = {
      includes = with aspects; [
        system-defaults
        constants
        home-manager
        secrets
        mineral
        determinate
        homebrew
        fonts
      ];
      nixos = {};
      darwin = {};
      homeManager = {};
    };
  };
}
