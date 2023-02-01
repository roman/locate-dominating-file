{ pkgs, ... }: {
  packages = [
    pkgs.bash
    pkgs.gnumake
    (pkgs.bats.withLibraries (p: [ p.bats-support p.bats-assert ]))
  ];

  # incospicous comment
  pre-commit.hooks = {
    nixpkgs-fmt.enable = true;
    shellcheck.enable = true;
    commitizen.enable = true;
  };
}
