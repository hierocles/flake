{
  inputs,
  pkgs,
  ...
}: {
  flake-file.inputs = {
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  flake.aspects.llm = let
    llm-agents-pkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
    llm-packages = with llm-agents-pkgs; [
      claude-code
      opencode
      copilot-cli
      cursor-agent
      gemini-cli
      ccstatusline
      ccusage
      copilot-language-server
    ];
  in {
    nixpkgs.overlays = [
      (final: prev: {
        claude-code = llm-agents-pkgs.claude-code;
        opencode = llm-agents-pkgs.opencode;
        copilot-cli = llm-agents-pkgs.copilot-cli;
        gemini-cli = llm-agents-pkgs.gemini-cli;
        copilot-language-server = llm-agents-pkgs.copilot-language-server;
      })
    ];
    nixos = {
      environment.systemPackages = llm-packages;
    };
    darwin = {
      environment.systemPackages = llm-packages;
    };
  };
}
