_: {
  flake.aspects.nodejs = let
    makeConfig = pkgs: {
      environment.systemPackages = with pkgs; [
        nodejs
        nodePackages.npm
      ];
    };
    makeHomeConfig = pkgs: {
      home.packages = with pkgs; [
        nodePackages.pnpm
        nodePackages.yarn
      ];
    };
  in {
    nixos = {pkgs, ...}: makeConfig pkgs;
    darwin = {pkgs, ...}: makeConfig pkgs;
    homeManager = {pkgs, ...}: makeHomeConfig pkgs;
  };
}
