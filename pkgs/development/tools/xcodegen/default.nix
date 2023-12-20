{ stdenv, swift, swiftpm, swiftpm2nix, fetchFromGitHub }:

let
  generated = swiftpm2nix.helpers ./nix;
in

stdenv.mkDerivation rec {
  pname = "xcodegen";
  version = "2.38.0";

  src = fetchFromGitHub {
    owner = "yonaskolb";
    repo = pname;
    rev = version;
    hash = "sha256-5N0ZNQec1DUV4rWqqOC1Aikn+RKrG8it0Ee05HG2mn4=";
  };

  nativeBuildInputs = [ swift swiftpm ];
  buildInputs = [ ];

  configurePhase = generated.configure;

  buildPhase = ''
    runHook preBuild

    TERM=dumb swift build -c release --product xcodegen

    runHook postBuild
  '';

  installPhase = ''
    binPath="$(swiftpmBinPath)"
    # Now perform any installation steps.
    mkdir -p $out/bin
    cp $binPath/xcodegen $out/bin/
  '';
}

