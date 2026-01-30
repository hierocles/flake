{inputs, ...}: {
  perSystem = {system, ...}: {
    packages = {
      iso = inputs.self.lib.mkIsoImage system "iso";
    };
  };
}
