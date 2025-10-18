{ 
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    x2container.url = "github:dialohq/x2container.nix";
  };

  outputs = inputs@{ flake-parts, x2container, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: 
      {
        packages.default = x2container.lib.${system}.uv2container.buildImage {
          name = "example";
          src = ./.;
          python = pkgs.python312;
          runtimeLibs = [ pkgs.hello ];
          config = {
            cmd = [ "python" "./hello.py" ];
          };
        };

        packages.container-as-dir = pkgs.runCommand "docker-as-dir" { }
            "${self'.packages.default.copyTo}/bin/copy-to dir:$out";

        devShells.default = pkgs.mkShell { inputsFrom = [ self'.packages.default ]; };
      };
    };
}

