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
      ];
      nixos = {};
      darwin = {};
      homeManager = {};
    };
  };
}
