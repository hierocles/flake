_: {
  flake.aspects.fonts = let
    makeConfig = pkgs: let
      nf = with pkgs.nerd-fonts; [
        caskaydia-cove
        meslo-lg
        symbols-only
      ];
    in {
      fonts.packages = nf;
    };
  in {
    nixos = {pkgs, ...}: makeConfig pkgs;
    darwin = {pkgs, ...}: makeConfig pkgs;
  };
}
