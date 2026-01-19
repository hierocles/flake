{
  flake.aspects = {aspects, ...}: {
    developer = {
      includes = with aspects; [
        nodejs
        bun
        python
        direnv
        devenv
        llm
        ide
        typescript
        react
      ];
      nixos = {};
      darwin = {};
      homeManager = {};
    };
  };
}
