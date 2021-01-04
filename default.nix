let
  pkgs = import (fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-20.03.tar.gz) {};
  stdenv = pkgs.stdenv;
  jlink = stdenv.mkDerivation {
    buildInputs = [
      pkgs.glibc
      pkgs.libudev0-shim
      pkgs.gnutar
      pkgs.ncurses5
      pkgs.gcc-unwrapped
      pkgs.freetype
      pkgs.xorg.libSM
      pkgs.xorg.libICE
      pkgs.xorg.libXrender
      pkgs.xorg.libXrandr
      pkgs.xorg.libXfixes
      pkgs.xorg.libXcursor
      pkgs.xorg.libXext
      pkgs.fontconfig
      pkgs.xorg.libX11
    ];
    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    name = "jlink";
    src = ./jlink.tgz;
    system = "x86_64-linux";
    installPhase = ''
      mkdir -p $out/lib/udev/rules.d
      mv * $out/
      sed -i 's/0x//g' $out/99-jlink.rules
      patch -i ${./99-jlink.rules.patch} $out/99-jlink.rules
      mv $out/99-jlink.rules $out/lib/udev/rules.d/
    '';
  };
  ozone = stdenv.mkDerivation {
    buildInputs = [
      jlink
      pkgs.gcc-unwrapped
      pkgs.freetype
      pkgs.xorg.libSM
      pkgs.xorg.libICE
      pkgs.xorg.libXrender
      pkgs.xorg.libXrandr
      pkgs.xorg.libXfixes
      pkgs.xorg.libXcursor
      pkgs.xorg.libXext
      pkgs.fontconfig
      pkgs.xorg.libX11
    ];
    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    system = "x86_64-linux";
    name = "ozone";
    src = ./ozone.tgz;
    installPhase = ''
      mkdir -p $out/
      mv * $out
    '';
  };
in
ozone
