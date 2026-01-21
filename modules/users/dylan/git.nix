{
  flake.aspects.dylan._.git = {
    homeManager = {config, ...}: {
      programs.git = {
        enable = true;
        settings = {
          user = {
            inherit (config.constants.admin) email;
            name = "hierocles";
          };
        };
        #signing = {
        #  format = "openpgp";
        #  key = "";
        #  signByDefault = false;
        #};
      };
    };
  };
}
