{pkgs, ...}: {
  flake.aspects.fonts = let
    nf = with pkgs.nerd-fonts; [
      caskaydia-cove
      meslo-lg
      symbols-only
    ];
  in {
    nixos = {
      fonts.packages = nf;
    };
    darwin = {
      fonts.packages = nf;
    };
  };
}
