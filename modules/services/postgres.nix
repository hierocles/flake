{pkgs, ...}: {
  flake.aspects.postgres = {
    nixos = {
      services.postgresql = {
        enable = true;
        package = pkgs.postgresql;
        settings = {
          max_connections = 100;
          shared_buffers = "256MB";
        };
      };
    };
    darwin = {
      # PostgreSQL on macOS via Homebrew managed separately
    };
    homeManager = {
      home.packages = with pkgs; [
        postgresql
      ];
    };
  };
}
