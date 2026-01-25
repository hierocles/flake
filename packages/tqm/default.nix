{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "tqm";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "autobrr";
    repo = "tqm";
    rev = "v${version}";
    hash = "sha256-FO82DXMNZn00WEnUYrPKBLcYrqHi3vH5yzfCmIAEJoU=";
  };

  vendorHash = "sha256-IUAqY4w0Akm1lJJU5fZkVQpc5fWUx/88+hAinwZN3y4=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  doCheck = false;

  meta = with lib; {
    description = "TQM: Torrent Queue Manager, a tool to manage torrents in your clients";
    homepage = "https://github.com/autobrr/tqm";
    license = licenses.gpl3Only;
    maintainers = with lib.maintainers; [hierocles];
    platforms = platforms.linux;
    mainProgram = "tqm";
  };
}
