{
  bats,
  bash,
  lib,
  stdenv,
  getopt,
}: let
  batsPkg = bats.withLibraries (p: [p.bats-support p.bats-assert]);
in
  stdenv.mkDerivation {
    name = "locate-dominating-file";
    version = "v0.0.1";
    src = ./.;

    doCheck = true;

    postPatch = ''
      for file in $(find src tests -type f); do
        substituteInPlace "$file" --replace "/bin/bash" "${bash}/bin/bash"
        substituteInPlace "$file" --replace "#!/usr/bin/env bash" "#!${bash}/bin/bash"
      done
    '';

    buildInputs = [getopt];

    installPhase = ''
      mkdir -p $out/bin
      cp src/locate-dominating-file.sh $out/bin/locate-dominating-file
    '';

    checkPhase = ''
      ${batsPkg}/bin/bats -t tests
    '';

    meta = with lib; {
      description = "Program that looks up in a directory hierarchy for a given filename";
      license = licenses.mit;
      maintainers = [maintainers.roman];
      platforms = platforms.all;
    };
  }
