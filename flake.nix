{
  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;

      inherit (lib.attrsets) genAttrs;
      inherit (lib.systems) flakeExposed;

      eachSystem = f: genAttrs flakeExposed (system: f nixpkgs.legacyPackages.${system});
    in
    {
      devShells = eachSystem (pkgs: {
        default = pkgs.mkShell { packages = [ pkgs.bun ]; };
      });
    };
}
