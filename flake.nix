{
  description = "mdBook flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils = { url = "github:numtide/flake-utils"; };
    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, gitignore }:
    let inherit (gitignore.lib) gitignoreSource;
    in flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages = rec {
          mdBook = pkgs.callPackage ./default.nix {
            inherit gitignoreSource;
            CoreServices = pkgs.darwin.apple_sdk.frameworks.CoreServices;
          };
          default = mdBook;
        };
      });
}
