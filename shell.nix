{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    ocamlPackages.ocaml-lsp
    
  ];
}
