{pkgs, ...}: {
  flake.aspects.typescript = {
    homeManager = {
      home.packages = with pkgs; [
        nodePackages.typescript
        nodePackages.ts-node
      ];
    };
  };
}
