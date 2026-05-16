{self, ...}: {
  flake.aspects.nh = let
    flake = "(builtins.getFlake \"${self}\")";
    makeConfig = pkgs: {
      programs.nh = {
        enable = true;
        flake = "${flake}";
        clean.enable = true;
      };
    };
  in {
    nixos = {pkgs, ...}: makeConfig pkgs;
    darwin = {pkgs, ...}: makeConfig pkgs;
  };
}
