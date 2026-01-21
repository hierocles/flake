{...}: {
  flake.aspects.docker = let
    makeHomeConfig = pkgs: {
      home.packages = with pkgs; [
        docker-compose
      ];
    };
  in {
    nixos = {
      virtualisation.docker = {
        enable = true;
        autoPrune.enable = true;
      };
    };
    homeManager = {pkgs, ...}: makeHomeConfig pkgs;
  };
}
