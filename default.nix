{ bats
, bash
, lib
, stdenvNoCC
, getopt
,
}:
let
  version = "0.0.1";
in
stdenvNoCC.mkDerivation {
  pname = "locate-dominating-file";
  inherit version;
  src = ./.;

  doCheck = true;

  postPatch = ''
    for file in $(find src tests -type f); do
      patchShebangs "$file"
    done
  '';

  buildInputs = [ getopt ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp src/locate-dominating-file.sh $out/bin/locate-dominating-file

    runHook postInstall
  '';

  checkInputs = [ (bats.withLibraries (p: [ p.bats-support p.bats-assert ])) ];

  checkPhase = ''
    runHook preCheck

    bats -t tests

    runHook postCheck
  '';

  meta = with lib; {
    description = "Program that looks up in a directory hierarchy for a given filename";
    license = licenses.mit;
    maintainers = [ maintainers.roman ];
    platforms = platforms.all;
  };
}
