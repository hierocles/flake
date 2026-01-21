{inputs, ...}: {
  flake.aspects = {aspects, ...}: {
    macbook = {
      includes = with aspects; [
        system-essentials
        dylan
      ];
      darwin = {
        networking.hostName = "macbook";
        system.primaryUser = "dylan";
        homebrew = {
          enable = true;
          masApps = {
            "Numbers" = 409203825;
            "Pages" = 409201541;
            "Keynote" = 409183694;
            "iMovie" = 408981434;
          };
        };
        # Connect transposed homeManager configs to the user
        home-manager.users.dylan.imports = [
          inputs.self.modules.homeManager.constants
          inputs.self.modules.homeManager.dylan
        ];
      };
    };
  };

  flake.darwinConfigurations = inputs.self.lib.mkDarwin "aarch64-darwin" "macbook";
}
