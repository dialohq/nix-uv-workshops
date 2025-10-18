{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
  # aarch64-darwin
  # aarch64-linux
  let pkgs = nixpkgs.legacyPackages.aarch64-darwin;
  in {
    packages.aarch64-darwin.default = pkgs.hello;
    devShells.aarch64-darwin.default = pkgs.mkShell {
      packages = [
        pkgs.ffmpeg
      ];
    };
  };
}
