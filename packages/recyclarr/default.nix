# Vendored from nixpkgs `pkgs/by-name/re/recyclarr/package.nix` with a newer release.
# `buildDotnetModule`’s inner attrset hardcodes `nugetDeps = ./deps.json`, so `overrideAttrs`
# on `nixpkgs.recyclarr` cannot replace NuGet locks — use `callPackage` instead.
{
  lib,
  openssl,
  git,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  testers,
}:
buildDotnetModule (finalAttrs: {
  pname = "recyclarr";
  version = "8.6.0";

  src = fetchFromGitHub {
    owner = "recyclarr";
    repo = "recyclarr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Uu6fBKODzKGYA6vSJPw0OV/+bi3y2F/SHfrdd5pdyzs=";
  };

  # Whole-solution install pulls test projects into the same `$out/lib/recyclarr` and can fail (MSB3021 on v8.6.x).
  projectFile = "src/Recyclarr.Cli/Recyclarr.Cli.csproj";
  nugetDeps = ./deps.json;

  postPatch = ''
    cat > src/Recyclarr.Core/GitVersionInformation.g.cs <<'EOF'
    public static class GitVersionInformation
    {
        public static string SemVer => "${finalAttrs.version}";
        public static string FullBuildMetaData => "nixpkgs";
        public static string InformationalVersion => "${finalAttrs.version}+nixpkgs";
        public static int Major => ${lib.versions.major finalAttrs.version};
    }
    EOF

    rm .config/dotnet-tools.json
  '';

  doCheck = false;

  dotnetBuildFlags = [
    "-p:DisableGitVersionTask=true"
    "/m:1"
  ];

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;

  executables = ["recyclarr"];
  makeWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        git
        openssl
      ]
    }"
  ];

  passthru = {
    tests.version = testers.testVersion {package = finalAttrs.finalPackage;};
  };

  meta = {
    description = "Automatically sync TRaSH guides to your Sonarr and Radarr instances";
    homepage = "https://recyclarr.dev/";
    changelog = "https://github.com/recyclarr/recyclarr/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      josephst
      aldoborrero
    ];
    mainProgram = "recyclarr";
    sourceProvenance = with lib.sourceTypes; [fromSource];
  };
})
