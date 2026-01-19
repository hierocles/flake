{
  flake.aspects.terminals = {
    darwin = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        ghostty
        iterm2
      ];
    };

    homeManager = {pkgs, ...}: {
      home.packages = with pkgs; [
        ghostty
        kitty
        wezterm
      ];
    };
  };
}
