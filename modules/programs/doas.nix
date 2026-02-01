{
  flake.aspects.doas = let
    doas = {
      security.sudo.enable = false;
      security.doas = {
        enable = true;
        extraRules = [
          {
            groups = ["wheel"];
            users = ["dylan"];
            persist = true;
            keepEnv = true;
          }
        ];
      };
      environment.shellAliases = {
        sudo = "doas";
      };
    };
  in {
    nixos = doas;
    darwin = doas;
  };
}
