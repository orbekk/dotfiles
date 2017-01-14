{ nixpkgs ? <nixpkgs>, ...}:

with import nixpkgs {};

{
  vlc-nightly = callPackage ./vlc-nightly.nix {};
}
