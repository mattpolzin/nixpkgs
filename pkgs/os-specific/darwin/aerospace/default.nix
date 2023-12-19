{ lib
, stdenvNoCC
, fetchFromGitHub
, asciidoctor
, gnused
#, testers
#, xxd
#, xcodebuild
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "aerospace";
  version = "0.7.1-Beta";

  src = fetchFromGitHub {
    owner = "nikitabobko";
    repo = "AeroSpace";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dUnbTnsFq/q5mFFai01z+Oxx5yPGScUXFJ7PB/bEgls=";
  };

  nativeBuildInputs = [
    asciidoctor
    gnused
#    installShellFiles
#    xcodebuild
#    xxd
  ];

  buildInputs = [
#    Carbon
#    Cocoa
#    ScriptingBridge
#    SkyLight
  ];

  dontConfigure = true;
  enableParallelBuilding = true;

  env = {
    # silence service.h error
#    NIX_CFLAGS_COMPILE = "-Wno-implicit-function-declaration";
  };

  postPatch = ''
    substituteInPlace ./build-docs.sh \
      --replace "git rev-parse HEAD" "echo ${finalAttrs.version}" \
      --replace "git status --porcelain" ""

    substituteInPlace ./generate.sh \
      --replace "gsed" "${gnused}/bin/sed" \
  '';

  buildPhase = ''
    runHook preBuild

    ./build-release.sh

    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck

    ./run-tests.sh

    runHook postCheck
  '';

#  installPhase = ''
#    runHook preInstall
#
#    mkdir -p $out/{bin,share/icons/hicolor/scalable/apps}
#
#    cp ./bin/yabai $out/bin/yabai
#    cp ./assets/icon/icon.svg $out/share/icons/hicolor/scalable/apps/yabai.svg
#    installManPage ./doc/yabai.1
#
#    runHook postInstall
#  '';

#  passthru.tests.version = test-version;

#  meta = _meta // {
#    sourceProvenance = with lib.sourceTypes; [
#      fromSource
#    ];
#  };
})
