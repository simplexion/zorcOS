let
  nixos = import <nixpkgs/nixos> {
    configuration = import ./image.nix;
  };
in
nixos.config.system.build.sdImage // {
  inherit (nixos) pkgs system config pkgs_src;
}
