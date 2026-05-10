_: {
  flake.aspects.nodejs = let
    makeConfig = pkgs: {
      environment.systemPackages = with pkgs; [
        nodejs
        pnpm
      ];
    };
    makeHomeConfig = pkgs: {
      home.packages = with pkgs; [
        pnpm
        yarn
      ];
    };
  in {
    nixos = {pkgs, ...}: makeConfig pkgs;
    darwin = {pkgs, ...}: makeConfig pkgs;
    homeManager = {pkgs, ...}: makeHomeConfig pkgs;
  };
}
