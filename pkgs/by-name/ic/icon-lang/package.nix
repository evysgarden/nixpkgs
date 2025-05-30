{
  lib,
  stdenv,
  fetchFromGitHub,
  libX11,
  libXt,
  withGraphics ? true,
}:

stdenv.mkDerivation {
  pname = "icon-lang";
  version = "unstable-2020-02-05";
  src = fetchFromGitHub {
    owner = "gtownsend";
    repo = "icon";
    rev = "829cff33de4a21546fb269de3ef5acd7b4f0c0c7";
    sha256 = "1lj2f13pbaajcy4v3744bz46rghhw5sv4dwwfnzhsllbj5gnjsv2";
  };

  buildInputs = lib.optionals withGraphics [
    libX11
    libXt
  ];

  configurePhase =
    let
      target = if withGraphics then "X-Configure" else "Configure";
      platform =
        if stdenv.hostPlatform.isLinux then
          "linux"
        else if stdenv.hostPlatform.isDarwin then
          "macintosh"
        else if stdenv.hostPlatform.isBSD then
          "bsd"
        else if stdenv.hostPlatform.isCygwin then
          "cygwin"
        else if stdenv.hostPlatform.isSunOS then
          "solaris"
        else
          throw "unsupported system";
    in
    "make ${target} name=${platform}";

  installPhase = ''
    make Install dest=$out
    rm $out/README
    mkdir -p $out/share/doc
    mv $out/doc $out/share/doc/icon
  '';

  meta = with lib; {
    description = "Very high level general-purpose programming language";
    maintainers = with maintainers; [ yurrriq ];
    platforms = with platforms; linux ++ darwin ++ freebsd ++ netbsd ++ openbsd ++ cygwin ++ illumos;
    license = licenses.publicDomain;
    homepage = "https://www.cs.arizona.edu/icon/";
  };
}
