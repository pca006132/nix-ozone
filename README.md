# Segger Ozone Nix package (WIP)
## Build
1. Download the tarballs. To speed things up, I just use a hard-coded path.
   The tarball can be downloaded from
   ```sh
   # shamelessly copied from AUR
   curl -o ozone.tgz https://www.segger.com/downloads/jlink/Ozone_Linux_V322a_x86_64.tgz
   curl -o jlink.tgz -d accept_license_agreement=accepted -d non_emb_ctr=confirmed https://www.segger.com/downloads/jlink/JLink_Linux_V692_x86_64.tgz
   ```
2. Check the hash.
3. Run `nix-build`, and `result/bin/ozone`.

A GUI should show up.  No access to hardware now so idk if this actually works.
Especially the drivers, udev rules etc.

It seems that the package requires FHS. Adding `autoPatchelfHook` would trigger
[NixOS/patchelf#255](https://github.com/NixOS/patchelf/issues/255).

References:
- https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=jlink-software-and-documentation
- https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=ozone

