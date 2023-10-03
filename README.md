# NixOS ARM
Nix expressions for building NixOS images for ARM SBCs.

## TL;DR
```shell
export \
MACHINE=raspberry-pi-3 \
SD_CARD=/dev/sda \
NIXPKGS_REV=ea4c80b

nix-build -I nixpkgs="https://github.com/NixOS/nixpkgs/archive/${NIXPKGS_REV}.tar.gz" -I machine=machines/$MACHINE --out-link out-links/$MACHINE
```

## Building

### Machines
Select one of the [machines](./machines/) and set the environment variable.
```shell
export MACHINE=raspberry-pi-3
```

### `nixpkgs` Versions
Select a [nixpkgs](https://github.com/NixOS/nixpkgs/) version and set the enviroment variable.
```shell
export NIXPKGS_REV=ea4c80b
```

It's recommended to set it to one of the revision hashes from the table below.
But you can also set it to a branch name like `nixos-23.05`.

| ref         | rev       | date       |
|-------------|-----------|------------|
| nixos-22.11 | `ea4c80b` | 2023-09-10 |
| nixos-23.05 | `c99004f` | 2023-07-06 |
| nixos-23.05 | `da5adce` | 2023-09-06 |
| nixos-23.05 | `32dcb45f66c0487e92db8303a798ebc548cadedc` | 2023-10-03 |

### Build
```shell
nix-build -I nixpkgs="https://github.com/NixOS/nixpkgs/archive/${NIXPKGS_REV}.tar.gz" -I machine=machines/$MACHINE --out-link out-links/$MACHINE
```

## Flashing
Select the correct block device and set the environment variable.
```shell
export SD_CARD=/dev/sda
sudo sh -c "zstd -dcf out-links/$MACHINE/sd-image/*.img.zst | dd status=progress bs=64k iflag=fullblock oflag=direct of=$SD_CARD && sync && eject $SD_CARD"
```

## Deployment
For deploying new images without reflashing, you can use [NixOps](https://github.com/NixOS/nixops).

```shell
nix-shell -p nixopsUnstable
```
Since stable NixOps reuqires Python2, we use the unstable version.
```shell
[nix-shell:~]$ nixops --version
NixOps 2.0.0-pre-fc9b55c
```

### Create
```shell
IP=10.0.0.33 nixops create -I nixpkgs="https://github.com/NixOS/nixpkgs/archive/${NIXPKGS_REV}.tar.gz" -I machine=machines/$MACHINE -d machine
```

### Deploy
```shell
IP=10.0.0.33 nixops deploy -I nixpkgs="https://github.com/NixOS/nixpkgs/archive/${PKGS_HASH}.tar.gz" -I machine=machines/$MACHINE
```
