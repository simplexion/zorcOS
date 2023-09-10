{ config, pkgs, lib, ... }:
{
  # cross compile
  nixpkgs.crossSystem = lib.systems.elaborate lib.systems.examples.aarch64-multiplatform;

  # # emulate
  # nixpkgs.system = "aarch64-linux";

  imports = [
    <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64.nix>
  ];
}
