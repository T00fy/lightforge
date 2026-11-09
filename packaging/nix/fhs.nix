{
  symlinkJoin,
  makeWrapper,
  steam-run-free,
  lightforge-unwrapped,
}:

# NixOS has no /lib/ld-linux.so.2 with or without hardware.graphics.enable32Bit,
# and Proton's binaries need it, so setup would stop at the 32-bit check.
# steam-run-free is steam-run without the unfree Steam package.
symlinkJoin {
  name = "${lightforge-unwrapped.pname}-${lightforge-unwrapped.version}";
  paths = [ lightforge-unwrapped ];
  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    # Whichever binaries the package built.
    for exe in ${lightforge-unwrapped}/bin/*; do
      bin=''${exe##*/}
      rm $out/bin/$bin
      makeWrapper ${steam-run-free}/bin/steam-run $out/bin/$bin \
        --add-flags ${lightforge-unwrapped}/bin/$bin
    done
  '';

  inherit (lightforge-unwrapped) version meta;
}
