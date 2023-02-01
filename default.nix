{ bats
, bash
, lib
, resholve
, coreutils
, getopt
}:
let
  version = "0.0.1";
in
resholve.mkDerivation {
  pname = "locate-dominating-file";
  inherit version;
  src = ./.;

  postPatch = ''
    for file in $(find src tests -type f); do
      patchShebangs "$file"
    done
  '';

  buildInputs = [ getopt coreutils ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp src/locate-dominating-file.sh $out/bin/locate-dominating-file

    runHook postInstall
  '';

  checkInputs = [ (bats.withLibraries (p: [ p.bats-support p.bats-assert ])) ];

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    bats -t tests

    runHook postCheck
  '';

  solutions.default = {
    scripts = [ "bin/locate-dominating-file" ];
    interpreter = "${bash}/bin/bash";
    inputs = [
      coreutils
      getopt
    ];
  };

  meta = with lib; {
    description = "Program that looks up in a directory hierarchy for a given filename";
    license = licenses.mit;
    maintainers = [ maintainers.roman ];
    platforms = platforms.all;
  };
}
