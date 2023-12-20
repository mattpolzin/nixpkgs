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
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  nativeBuildInputs = [ swift swiftpm ];

  configurePhase = generated.configure;

  installPhase = ''
    binPath="$(swiftpmBinPath)"
    # Now perform any installation steps.
    mkdir -p $out/bin
    cp $binPath/myproject $out/bin/
  '';
}

