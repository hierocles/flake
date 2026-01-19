{pkgs, ...}: {
  flake.aspects.tmux = let
    tmux = {
      environment.systemPackages = [
        pkgs.tmux
      ];
    };
  in {
    nixos = tmux;
    darwin = tmux;
  };
}
