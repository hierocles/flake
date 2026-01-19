{
  flake.aspects.constants = let
    constantsModule = {lib, ...}: {
      options.constants = lib.mkOption {
        type = lib.types.attrsOf lib.types.unspecified;
        default = {};
      };

      config.constants = {
        admin = {
          email = "4733259+hierocles@users.noreply.github.com";
          username = "dylan";
        };
      };
    };
  in {
    nixos = constantsModule;
    darwin = constantsModule;
    homeManager = constantsModule;
  };
}
