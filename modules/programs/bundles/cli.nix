# nh must stay in this file next to `cli.includes` so `with aspects; [ nh … ]` resolves (import-tree order).
{self, ...}: {
  flake.aspects = {aspects, ...}: {
    cli = {
      description = "CLI tools";
      includes = with aspects; [
        doas
        nh
        git
        nvchad
        tmux
        nh
        nom
        nvd
        just
        terminals
        starship
        nix-init
        secrets-management
      ];
      nixos = {};
      darwin = {};
      homeManager = {};
    };
  };
}
