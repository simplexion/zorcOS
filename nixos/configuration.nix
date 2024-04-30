{ config, pkgs, lib, ... }:
{
  imports = [
    ./minification.nix
    ./can.nix
    ./zorc.nix
    ./ethernet.nix
  ]
  ++ lib.optionals (builtins.pathExists ./hardware-configuration.nix) [ ./hardware-configuration.nix ]
  ++ lib.optionals (builtins.pathExists ./custom.nix) [ ./custom.nix ];

  boot.loader.grub.enable = false;

  environment.systemPackages = with pkgs; [
    screen
    vim
    htop
    bottom
  ];

  users = {
    extraUsers.nixos = {
      isNormalUser = true;
      initialPassword = "nixos";
      extraGroups = [ "wheel" "video" "input" "dialout" "gpio" "i2c" "plugdev" ];
    };
  };

  # needed for nixops
  security.sudo.wheelNeedsPassword = false;
  nix.settings.trusted-users = [ "nixos" ];

  networking  = {
    hostName = "zorc";
    wireless = {
      enable = true;
      userControlled.enable = true;
    };
  };

  services = {
    # getty.autologinUser = "nixos";
    openssh = {
      enable = true;
      settings.PasswordAuthentication = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  system.stateVersion = "nixos-${lib.versions.major lib.version}.${lib.versions.minor lib.version}";
}
