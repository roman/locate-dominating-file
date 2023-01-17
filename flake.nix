{
  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    devenv = {
      url = "github:cachix/devenv/latest";
      inputs.pre-commit-hooks.url = "github:roman/pre-commit-hooks.nix/roman/checker/bats-support";
      inputs.pre-commit-hooks.inputs.nixpkgs.follows = "devenv/nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , devenv
    , ...
    } @ inputs: {
      packages = flake-utils.lib.eachDefaultSystemMap (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.callPackage ./default.nix { };
        });
      devShells = flake-utils.lib.eachDefaultSystemMap (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = devenv.lib.mkShell {
            inherit pkgs inputs;
            modules = [
              (import ./devenv.nix)
            ];
          };
        });
    };
}
