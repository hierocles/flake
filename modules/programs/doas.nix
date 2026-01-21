{
  flake.aspects.doas = let
    doas = {
      security.sudo.enable = false;
      security.doas = {
        enable = true;
        extraRules = [{
          groups = ["wheel"];
          users = ["dylan"];
          persist = true;
          keepEnv = true;
        }];
      };
    };
  in {
    nixos = doas;
    darwin = doas;
  };
}
