{ buildPythonPackage
, fetchFromGitHub

, cadquery
, setuptools
, tkinter
}:

buildPythonPackage rec {
  pname = "cq_warehouse";
  version = "0.8.0";
  src = fetchFromGitHub {
    owner = "gumyr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Lo8+9Wk1AZjm+imYaD1d0w9B1MOI4OMQaKdQ3onRnro=";
  };
  format = "pyproject";
  nativeBuildInputs = [ setuptools ];
  propagatedBuildInputs = [ cadquery tkinter ];
}
