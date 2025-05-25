{
  description = "A development environment for ocamlbyexample";

  inputs = {
    nixpkgs.url = "github:nix-ocaml/nix-overlays";
    flake-utils.url = "github:numtide/flake-utils";
    forester.url = "sourcehut:~jonsterling/ocaml-forester";
    forester.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, flake-utils, forester, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}".extend (self: super: {
          ocamlPackages = super.ocaml-ng.ocamlPackages_5_2;
        });
        ocamlPackages = pkgs.ocamlPackages;
        packages = [
          # ocamlPackages.utop
        ];
      in
      {
        formatter = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
        defaultPackage = pkgs.stdenv.mkDerivation {
          name = "ocamlbyexample";
          src = ./.;
        };

        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs.ocamlPackages; [ cppo findlib ];

          buildInputs = with pkgs; [
            # TODO: fix findlib cURL dependency
            # forester.packages.${system}.default
            packages
            opam
          ];
        };
      }
    );
}
