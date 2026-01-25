_: {
  flake.aspects = {aspects, ...}: {
    dylan = {
      includes = with aspects; [
        cli
        developer
        dylan._.ssh
        dylan._.git
        dylan._.gpg
        dylan._.tmux
        dylan._.nvchad
        dylan._.ide
        dylan._.secrets
      ];
      nixos = {pkgs, ...}: {
        programs.fish.enable = true;
        users.users.dylan = {
          isNormalUser = true;
          initialPassword = "ChangeMe";
          shell = pkgs.fish;
          extraGroups = ["wheel"];
        };
      };
      darwin = {pkgs, ...}: {
        programs.fish.enable = true;
        system.primaryUser = "dylan";
        users.users.dylan = {
          name = "dylan";
          shell = pkgs.fish;
        };
      };
      homeManager = {
        home.username = "dylan";
        home.stateVersion = "25.11";
        programs.fish.enable = true;
      };
    };
  };
}
