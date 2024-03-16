{ lib
, stdenv
, fetchFromGitHub
, cmake
, unstableGitUpdater
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rapidcheck";
  version = "unstable-2023-12-14-patched";

  src = fetchFromGitHub {
    owner = "lockshaw";
    repo  = "rapidcheck";
    rev   = "7f82845ac2b10fa854c739ce2af4497cd8604387";
    hash  = "sha256-glGppNX+bpMADWZRea1U8+afC0lCbtze6Bn3ci2obPs=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "RC_INSTALL_ALL_EXTRAS" true)
  ];

  passthru = {
    updateScript = unstableGitUpdater { };
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = with lib; {
    description = "A C++ framework for property based testing inspired by QuickCheck";
    inherit (finalAttrs.src.meta) homepage;
    maintainers = with maintainers; [ ];
    license = licenses.bsd2;
    pkgConfigModules = [
      "rapidcheck"
      # Extras
      "rapidcheck_boost"
      "rapidcheck_boost_test"
      "rapidcheck_catch"
      "rapidcheck_doctest"
      "rapidcheck_gtest"
    ];
    platforms = platforms.all;
  };
})
