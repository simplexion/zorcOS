{ pkgs, ... }:

{   
  boot.loader.raspberryPi.firmwareConfig = ''
    dtoverlay=mcp2515-can0,oscillator=16000000,interrupt=25
    
  '';

  environment.systemPackages = with pkgs; [
    can-utils
  ];
}
