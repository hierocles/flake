{pkgs, ...}: {
  flake.aspects.redis = {
    nixos = {
      services.redis.servers."" = {
        enable = true;
        port = 6379;
        bind = "127.0.0.1";
      };
    };
    darwin = {
      # Redis on macOS via Homebrew managed separately
    };
    homeManager = {
      home.packages = with pkgs; [
        redis
      ];
    };
  };
}
