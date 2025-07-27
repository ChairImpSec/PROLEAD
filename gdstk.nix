{ lib
, stdenv
, fetchFromGitHub
, cmake
, qhull
, zlib
}:

stdenv.mkDerivation rec {
  pname = "gdstk";
  version = "0.9.60";

  src = fetchFromGitHub {
    owner = "heitzmann";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QSVwP2VOQ8dh0CfeA53aXQXGe9zg3rmDlz8a9NC8tuI=";
  };



  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    qhull
    zlib
  ];

  meta = with lib; {
    description = "Gdstk (GDSII Tool Kit) is a C++/Python library for creation and manipulation of GDSII and OASIS files.";
    homepage = "https://github.com/heitzmann/gdstk";
    license = licenses.boost;
    maintainers = with maintainers; [  ];
  };
}
