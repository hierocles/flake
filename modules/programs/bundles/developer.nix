{
  flake.aspects = {aspects, ...}: {
    developer = {
      includes = with aspects; [
        nodejs
        bun
        python
        direnv
        devshell
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
