{pkgs, ...}: {
  flake.aspects.docker = {
    nixos = {
      virtualisation.docker = {
        enable = true;
        autoPrune.enable = true;
      };
    };
    homeManager = {
      home.packages = with pkgs; [
        docker-compose
      ];
    };
  };
}
