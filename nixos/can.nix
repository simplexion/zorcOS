{ pkgs, ... }:

{
  boot.loader.raspberryPi.firmwareConfig = ''
    dtoverlay=mcp2515-can1,oscillator=16000000,interrupt=24
  '';

  environment.systemPackages = with pkgs; [
    can-utils
  ];
}
