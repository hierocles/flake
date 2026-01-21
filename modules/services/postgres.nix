_: {
  flake.aspects.postgres = let
    makeNixosConfig = pkgs: {
      services.postgresql = {
        enable = true;
        package = pkgs.postgresql;
        settings = {
          max_connections = 100;
          shared_buffers = "256MB";
        };
      };
    };
    makeHomeConfig = pkgs: {
      home.packages = with pkgs; [
        postgresql
      ];
    };
  in {
    nixos = {pkgs, ...}: makeNixosConfig pkgs;
    darwin = {
      # PostgreSQL on macOS via Homebrew managed separately
    };
    homeManager = {pkgs, ...}: makeHomeConfig pkgs;
  };
}
