_: {
  flake.aspects.tmux = let
    makeConfig = pkgs: {
      environment.systemPackages = [
        pkgs.tmux
      ];
    };
  in {
    nixos = {pkgs, ...}: makeConfig pkgs;
    darwin = {pkgs, ...}: makeConfig pkgs;
  };
}
