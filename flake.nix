{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";

    rust-overlay = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:oxalica/rust-overlay";
    };
  };

  outputs =
    { nixpkgs, rust-overlay, ... }:
    let
      inherit (nixpkgs) lib;
      eachSystem = lib.genAttrs lib.systems.flakeExposed;
    in
    {
      devShells = eachSystem (system: {
        default =
          let
            overlays = [ (import rust-overlay) ];
            pkgs = import nixpkgs { inherit system overlays; };

            rustToolchain = pkgs.rust-bin.stable.latest.default.override {
              targets = [ "wasm32-unknown-unknown" ];
            };
          in
          pkgs.mkShell {
            RUST_BACKTRACE = "1";
            RUSTFLAGS = "--cfg erase_components";

            packages = with pkgs; [
              leptosfmt
              rust-analyzer
              rustfmt
              rustToolchain
              trunk
            ];
          };
      });
    };
}
