{ config, pkgs, lib, ... }:
{
  imports = [
    ./minification.nix
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

  networking.wireless = {
    enable = true;
    userControlled.enable = true;
  };

  services = {
    # getty.autologinUser = "nixos";
    openssh = {
      enable = true;
      passwordAuthentication = if config.users.extraUsers.nixos.openssh.authorizedKeys.keys == [ ] then true else false;
      # forwardX11 = true;
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
