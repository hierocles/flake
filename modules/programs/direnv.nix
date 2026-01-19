{pkgs, ...}: {
  flake.aspects.direnv = {
    homeManager = {
      home.packages = with pkgs; [
        direnv
        nix-direnv
      ];

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      programs.fish.initExtra = ''
        ${pkgs.direnv}/bin/direnv hook fish | source
      '';
    };
  };
}
