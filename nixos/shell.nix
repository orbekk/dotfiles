{ nixpkgs ? <nixpkgs>, ...}:

with import nixpkgs {};

{
  vlc-nightly = callPackage ./vlc-nightly.nix {};
  stardew-valley = callPackage ./stardew-valley.nix {};
}
