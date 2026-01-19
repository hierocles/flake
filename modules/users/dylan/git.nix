{
  flake.aspects.dylan._.git = {
    homeManager = {config, ...}: {
      programs.git = {
        settings = {
          name = "hierocles";
          email = config.constants.admin.email;
        };
        signing = {
          format = "openpgp";
          key = "";
          signByDefault = true;
        };
      };
    };
  };
}
