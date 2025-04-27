{
  inputs.unison = {
    url = "github:bcpierce00/unison/v2.53.7";
    flake = false;
  };
  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = { unison, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.default = pkgs.runCommand "unison"
          {
            buildInputs = [
              pkgs.gnumake
              pkgs.ocaml
              pkgs.gcc
            ];
          }
          ''
            cp -r ${unison}/. .
            chmod a+rwX -R .
            make
            mkdir -p $out/bin
            cp src/unison $out/bin/
          '';
      });
}
