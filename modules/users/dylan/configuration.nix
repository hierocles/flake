{
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
      ];
      nixos = {pkgs, ...}: {
        programs.fish.enable = true;
        users.users.dylan = {
          isNormalUser = true;
          initialPassword = "";
          shell = pkgs.fish;
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
      };
    };
  };
}
