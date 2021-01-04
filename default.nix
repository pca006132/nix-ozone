let
  pkgs = import <nixpkgs> {};
  stdenv = pkgs.stdenv;
  jlink = stdenv.mkDerivation {
    buildInputs = [
      pkgs.glibc
      pkgs.libudev0-shim
      pkgs.gnutar
      pkgs.ncurses5
      pkgs.gcc-unwrapped
    ];
    name = "jlink";
    src = ./jlink.tgz;
    system = "x86_64-linux";
    installPhase = ''
      mkdir -p $out/lib/udev/rules.d
      cp --preserve=mode -r * $out/
      sed -i 's/0x//g' 99-jlink.rules
      patch -i ${./99-jlink.rules.patch} 99-jlink.rules
      mv 99-jlink.rules $out/lib/udev/rules.d/
    '';
  };
  ozone = stdenv.mkDerivation {
    buildInputs = [ jlink ];
    system = "x86_64-linux";
    name = "ozone";
    src = ./ozone.tgz;
    installPhase = ''
      mkdir -p $out/
      cp --preserve=mode -r * $out
    '';
  };
in
pkgs.buildFHSUserEnv {
  name = "ozone";
  targetPkgs = pkgs: [ ozone ];
  multiPkgs = pkgs: [
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
  runScript = "${ozone}/Ozone";
}
