{
  flake.aspects.dylan._.gpg = {
    homeManager = {
      services.gpg-agent = {
        enableFishIntegration = true;
        sshKeys = [
          "A6BF41F3F1712224033124B9FAEFA4967CE24E5A"
        ];
      };
      programs.gpg = {
        publicKeys = [
          {
            source = ./pub.gpg;
            trust = "ultimate";
          }
        ];
      };
    };
  };
}
