{ lib
, stdenv
, cmake
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "tbb";
  version = "2021.7.0";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneTBB";
    rev = "v${version}";
    hash = "sha256-Lawhms0yq5p8BrQXMy6dPe29dpSlHdSntum+6bAkpyo=";
  };

  nativeBuildInputs = [ cmake ];

  makeFlags = lib.optionals stdenv.cc.isClang [
    "compiler=clang"
  ] ++ (lib.optional (stdenv.buildPlatform != stdenv.hostPlatform)
    (if stdenv.hostPlatform.isAarch64 then "arch=arm64"
    else if stdenv.hostPlatform.isx86_64 then "arch=intel64"
    else throw "Unsupported cross architecture"));

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Intel Thread Building Blocks C++ Library";
    homepage = "http://threadingbuildingblocks.org/";
    license = licenses.asl20;
    longDescription = ''
      Intel Threading Building Blocks offers a rich and complete approach to
      expressing parallelism in a C++ program. It is a library that helps you
      take advantage of multi-core processor performance without having to be a
      threading expert. Intel TBB is not just a threads-replacement library. It
      represents a higher-level, task-based parallelism that abstracts platform
      details and threading mechanisms for scalability and performance.
    '';
    platforms = platforms.unix;
  };
}
