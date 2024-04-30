{ pkgs, ... }:
with pkgs;
let
  setup_can = writeScriptBin "setup_can" ''
    #!${bash}/bin/bash
    
    set -euxo pipefail
    
    if [ ! -d /sys/class/net/$1 ]
    then
      echo "No $1 found"
      ls /sys/class/net/
      exit 19 
    fi
    
    # diasble interface to be thorough
    ${iproute2}/bin/ip link set down $1
    
    # set symbol rate
    ${iproute2}/bin/ip link set $1 type can bitrate $2
    
    # enable interface
    ${iproute2}/bin/ip link set up $1
  '';

  canopend = stdenv.mkDerivation {
    pname = "canopend";
    version = "";

    src = fetchGit {
      url = "https://github.com/CANopenNode/CANopenLinux.git";
      rev = "ebcc3c8f01c9360c3a090267611e805bc78bd236";
      submodules = true;
    };

    installPhase = ''
      runHook preInstall
  
      mkdir -p $out/bin
      cp canopend $out/bin/
  
      runHook postInstall
    '';
  };

  zorc = stdenv.mkDerivation {
    name = "zorc";

    src = ../zorc;

    buildInputs = [
      systemd
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      install -m 555 zorc $out/bin/ 

      runHook postInstall
    '';
  };
in
{
  environment.systemPackages = with pkgs; [
    setup_can
    canopend
    zorc
    inetutils
  ];

  users = {
    groups.zorc = {};

    extraUsers = {
      zorc = {
        isSystemUser = true;
        home = "/var/lib/zorc";
        createHome = true;
        group = "zorc";
      };

      nixos.extraGroups = [ "zorc" ];
    };
  };

  systemd.services = {
    can0-setup = {
      enable = false;
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "Setup can0";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = ''${setup_can}/bin/setup_can can0 1000000'';
      };
    };
    canopend = {
      enable = false;
      wantedBy = [ "default.target" ];
      after = [ "can0-setup.service" ];
      serviceConfig = {
        ExecStart = ''${canopend}/bin/canopend can0 -i 2 -c "local-/tmp/CO_command_socket.socat"'';
        Nice = "-5";
        Restart = "always";
        RestartSec = "5";
        User = "zorc";
        WorkingDirectory = "/var/lib/zorc/";
      };
    };
  };
}
