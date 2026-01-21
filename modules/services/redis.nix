{...}: {
  flake.aspects.redis = let
    makeHomeConfig = pkgs: {
      home.packages = with pkgs; [
        redis
      ];
    };
  in {
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
    homeManager = {pkgs, ...}: makeHomeConfig pkgs;
  };
}
