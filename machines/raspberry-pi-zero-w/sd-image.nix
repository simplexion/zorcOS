{ config, pkgs, lib, ... }:
{
  # cross compile
  nixpkgs.crossSystem = lib.systems.elaborate lib.systems.examples.raspberryPi;

  # # emulate
  # nixpkgs.system = "armv6l-linux";

  imports = [
    <nixpkgs/nixos/modules/profiles/base.nix>
    <nixpkgs/nixos/modules/installer/sd-card/sd-image.nix>
  ];

  sdImage = {
    imageBaseName = "nixos-raspberry-pi-zero-w";
    populateRootCommands = "";
    populateFirmwareCommands = with config.system.build; ''
      ${installBootLoader} ${toplevel} -d ./firmware
      cp -r ${pkgs.raspberrypifw}/share/raspberrypi/boot/overlays/ ./firmware/
    '';
    firmwareSize = 64;
  };
}
