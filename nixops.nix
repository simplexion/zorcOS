let
  targetUser = "nixos";
in
{
  network.storage.legacy = {
    databasefile = "~/.nixops/deployments.nixops";
  };
  network.description = "ARM SBC";

  machine = { config, lib, pkgs, ... }: {
    deployment = {
      targetHost =
        let
          ip = builtins.getEnv "IP";
        in
        if ip == ""
        then throw "Please set the IP environment variable to the target device."
        else ip;
      targetUser = targetUser;
    };

    users.extraUsers."${targetUser}".openssh.authorizedKeys.keys =
      config.users.extraUsers.root.openssh.authorizedKeys.keys;

  } // import ./image.nix { };
}
