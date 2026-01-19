{pkgs, ...}: {
  flake.aspects.nodejs = let
    nodejs = {
      environment.systemPackages = with pkgs; [
        nodejs
        nodePackages.npm
      ];
    };
  in {
    nixos = nodejs;
    darwin = nodejs;
    homeManager = {
      home.packages = with pkgs; [
        nodePackages.pnpm
        nodePackages.yarn
      ];
    };
  };
}
