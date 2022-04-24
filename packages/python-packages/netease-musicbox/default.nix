{ python3, writeScript, writeText, fetchFromGitHub }: with python3.pkgs;
let
  runMusicBox = writeScript "musicbox" ''
    #!/usr/bin/env python
    import sys
    from NEMbox.__main__ import start
    sys.exit(start())
  '';
in
buildPythonApplication rec {
  pname = "NetEase-MusicBox";
  version = "0.3.2";
  format = "pyproject";

#   src = fetchPypi {
#     inherit pname version;
#     sha256 = "5468d145d720670bcd2963c7cac146c6da0b6ee2960f24b9a3d7436e155aade6";
#   };

  propagatedBuildInputs = [  
    requests-cache
    requests
    poetry
    fuzzywuzzy
    importlib-metadata
    pycryptodomex
  ];

  nativebuildInputs = [
    pkgs.poetry
  ];

  src = fetchFromGitHub {
    owner = "hilaolu";
    repo = "musicbox";
    rev = "${version}";
    sha256 = "sha256-mSucALmlpE+VGHUMO4ra+8hfXNPHTxmWd4w4OezgJEU="; # lib.fakeSha256
  };

  doCheck = false;

  preConfigure = ''
    # rm poetry.lock
    # echo $PATH
    # poetry lock
    # substituteInPlace poetry.lock --replace '"requests-cache = *"' '"requests-cache = "^0.9.0""'
  '';

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  postInstall = ''
    install -D ${runMusicBox} $out/bin/musicbox
  '';

}
