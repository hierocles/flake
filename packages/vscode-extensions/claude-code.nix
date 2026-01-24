{
  lib,
  vscode-utils,
  claude-code,
  makeWrapper,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "anthropic";
    name = "claude-code";
    version = "2.1.19";
    hash = "sha256-Qh7wUa+WK5FNsIcxJ2HxO1LHlRVdIcM7Y9ubtRONczc=";
  };
  nativeBuildInputs = [makeWrapper];
  postInstall = ''
    mkdir -p $out/bin
    makeWrapper ${claude-code}/bin/claude $out/bin/claude
  '';
  meta = {
    description = "Claude Code: Integrate Claude into VS Code";
    homepage = "https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview";
    license = lib.licenses.unfree;
    maintainers = [];
  };
}
