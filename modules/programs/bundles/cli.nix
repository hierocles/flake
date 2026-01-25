{
  flake.aspects = {aspects, ...}: {
    cli = {
      description = "CLI tools";
      includes = with aspects; [
        doas
        git
        nvchad
        tmux
        nom
        nvd
        just
        terminals
        starship
        nix-init
        tqm
      ];
      nixos = {};
      darwin = {};
      homeManager = {};
    };
  };
}
