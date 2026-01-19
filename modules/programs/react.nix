{pkgs, ...}: {
  flake.aspects.react = {
    homeManager = {
      home.packages = with pkgs; [
        nodePackages.create-react-app
        nodePackages.vite
        nodePackages.tailwindcss
        nodePackages.prettier-plugin-tailwindcss
      ];
    };
  };
}
