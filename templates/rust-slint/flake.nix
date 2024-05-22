{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
   
    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, crane, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (import rust-overlay)
          ];
        };

        rustToolchain = pkgs.rust-bin.stable.latest.default.override {
          targets = [
            "x86_64-unknown-linux-gnu"
          ];
        };

        craneLib = (crane.mkLib pkgs).overrideToolchain rustToolchain;

        commonArgs = with pkgs; {
          src = craneLib.cleanCargoSource (craneLib.path ./.);
          strictDeps = true;

          buildInputs =
            [
              stdenv.cc.cc.lib
            ] ++ (lib.optionals stdenv.isDarwin) [
              
            ];

          LD_LIBRARY_PATH = "$LD_LIBRARY_PATH:${
            lib.makeLibraryPath [
              wayland
              libxkbcommon
              fontconfig
              libGL
            ]
          }";
        };

        mainCrate = craneLib.buildPackage (commonArgs // {
          cargoArtifacts = craneLib.buildDepsOnly commonArgs;
        });
      in
        {
          packages.default = mainCrate;

          apps.default = flake-utils.lib.mkApp {
            drv = mainCrate;
          };

          devShells.default =
            craneLib.devShell.override {
              stdenv = pkgs.stdenvAdapters.useMoldLinker pkgs.clangStdenv;
            } {
              checks = self.checks.${system};

              inherit (commonArgs) LD_LIBRARY_PATH;
              RUST_SRC_PATH = rustToolchain.rust-src;

              packages = commonArgs.buildInputs;
            };
        }
    );
}
