{pkgs, ...}: {
  packages = [
    pkgs.bash
    pkgs.gnumake
    (pkgs.bats.withLibraries (p: [p.bats-support p.bats-assert]))
  ];
  pre-commit.hooks = {
    bats.enable = true;
    alejandra.enable = true;
    shellcheck.enable = true;
    commitizen.enable = true;
  };
}
