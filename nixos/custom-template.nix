{ pkgs, ... }:
{
  users.extraUsers.nixos.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAA..."
  ];

  networking.wireless = {
    networks = {
      myRouterSSID = {
        psk = "myRouterPassword";
      };
    };
  };
}
