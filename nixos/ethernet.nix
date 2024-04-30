{ pkgs, ... }:

{
  boot.loader.raspberryPi.firmwareConfig = ''
    dtoverlay=enc28j60,int_pin=25,speed=12000000
  '';
}
