_: {
  perSystem = {pkgs, ...}: {
    packages = {
      vscode-ext-claude-code = pkgs.callPackage ../../packages/vscode-extensions/claude-code.nix {};
    };
  };

  flake.overlays.default = final: prev: {
    vscode-extensions =
      prev.vscode-extensions
      // {
        anthropic =
          (prev.vscode-extensions.anthropic or {})
          // {
            claude-code = final.callPackage ../../packages/vscode-extensions/claude-code.nix {};
          };
      };
  };
}
