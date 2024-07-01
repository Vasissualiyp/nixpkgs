{ lib
, stdenv
, fetchFromGitHub
, mpi
, mpich
, tmux
, reptyr
, autoconf
}:

stdenv.mkDerivation rec {
  pname = "tmpi";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Azrael3000";
    repo = "tmpi";
    rev = "f5a0fd8848b5c87b301edc8a23de9bfcfbd41918";
    hash = "sha256-BaOaMpsF8ho8EIVuHfu4+CiVV3yLoC3tDkLq4R8BYBA=";
  };

  propagatedBuildInputs = [ mpi mpich reptyr tmux ];

  buildInputs = [ autoconf ];

  installPhase = ''
    runHook preInstall

    # Create a wrapper for the script to set the correct environment variables
    mkdir -p $out/bin
    cat > $out/bin/tmpi <<EOF
#!/usr/bin/env bash
export PATH=${lib.makeBinPath [ mpi mpich tmux reptyr ]}:\$PATH
$(cat tmpi)
EOF
    chmod +x $out/bin/tmpi

    runHook postInstall
  '';

  meta = {
    description = "Run a parallel command inside a split tmux window";
    mainProgram = "tmpi";
    homepage = "https://github.com/Azrael3000/tmpi";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ vasissualiyp ];
  };
}
