{
  description = "Python project";

  inputs.flake-compat.url = "github:edolstra/flake-compat";
  inputs.flake-compat.flake = false;
  inputs.nixpkgs = {
    url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.flake-utils.inputs.nixpkgs.follows = "nixpkgs";


  outputs = {
    flake-utils,
    nixpkgs,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system:
    let pkgs = nixpkgs.legacyPackages.${system}; in
     {
      formatter = nixpkgs.legacyPackages."${system}".alejandra;
      packages = {};
      devShell = pkgs.mkShell {
        packages = [
          pkgs.python313
          pkgs.uv
          pkgs.nil
          pkgs.nixfmt
        ];
        shellHook = ''
          uv sync
          source ./.venv/bin/activate
        '';
      };
    });
}
