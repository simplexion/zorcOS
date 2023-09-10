{ ... }: {
  imports = [
    <machine/sd-image.nix>
    <machine/hardware-configuration.nix>
    ./nixos/configuration.nix
  ];
}
