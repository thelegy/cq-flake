{
  gccSet
  , llvm-src
  , pywrap-src
  , ocp-src
  , ocp-stubs-src
  , cadquery-src
  , occt
  , fetchFromGitHub
  , vtk_9_nonpython
  , nlopt_nonpython
  , casadi_nonpython
  , pybind11-stubgen-src
}: final: prev: rec {
  clang = final.callPackage ./clang.nix {
    src = llvm-src;
    llvmPackages = gccSet.llvmPackages;
  };

  cadquery = final.callPackage ./cadquery.nix {
    src = cadquery-src;
  };

  cadquery_w_docs = final.callPackage ./cadquery.nix {
    documentation = true;
    src = cadquery-src;
  };

  casadi = final.toPythonModule casadi_nonpython;

  cq-kit = final.callPackage ./cq-kit {};

  cymbal = final.callPackage ./cymbal.nix { };

  dictdiffer = final.callPackage ./dictdiffer.nix { };

  ezdxf = final.callPackage ./ezdxf.nix { };

  geomdl = final.callPackage ./geomdl.nix { };

  jinja2 = prev.jinja2.overridePythonAttrs (oldAttrs: rec {
    version = "3.0.3";
    src = final.fetchPypi {
      inherit (oldAttrs) pname;
      inherit version;
      sha256 = "611bb273cd68f3b993fabdc4064fc858c5b47a973cb5aa7999ec1ba405c87cd7";
    };
  });

  # joblib = prev.joblib.overridePythonAttrs (oldAttrs: {
  #   checkInputs = [];
  #   doCheck = false;
  # });

  multimethod = final.callPackage ./multimethod.nix { };

  nlopt = final.toPythonModule nlopt_nonpython;

  nptyping = final.callPackage ./nptyping { };

  numpydoc = prev.numpydoc.overridePythonAttrs (oldAttrs: rec {
  #   # doCheck = false;
  #   # dontUsePytestCheck = true;
    version = "1.4.0";
    src = final.fetchPypi {
      inherit version;
      inherit (oldAttrs) pname;
      sha256 = "sha256-lJTa8cdhL1mQX6CeZcm4qQu6yzgE2R96lOd4gx5vz6U=";
    };
  });

  ocp = final.callPackage ./OCP {
    inherit (gccSet) stdenv llvmPackages;
    opencascade-occt = occt;
  };

  ocp-stubs = final.callPackage ./OCP/stubs.nix {
    src = ocp-stubs-src;
  };

  pybind11-stubgen = final.callPackage ./OCP/pybind11-stubgen.nix {
    src = pybind11-stubgen-src;
  };

  pytest-flakefinder = final.callPackage ./pytest-flakefinder.nix { };

  pywrap = final.callPackage ./pywrap {
    src = pywrap-src;
    inherit (gccSet) llvmPackages;
  };

  qdarkstyle = (prev.qdarkstyle.overrideAttrs (oldAttrs: rec {
    version = "3.0.2";
    src = final.fetchPypi {
      inherit version;
      pname = "QDarkStyle";
      sha256 = "sha256-VdFJz19A7ilzl/GBjgkRGM77hVpKnFw4VmxHrNLYx64=";
    };
  }));

  qstylizer = final.callPackage ./qstylizer.nix { };

  sphinx = final.callPackage ./sphinx.nix { };

  sphinx-autodoc-typehints = final.callPackage ./sphinx-autodoc-typehints.nix { };

  sphinx-issues = final.callPackage ./sphinx-issues.nix { };

  sphinxcadquery = final.callPackage ./sphinxcadquery.nix { };

  sphobjinv = final.callPackage ./sphobjinv.nix { };

  spyder = (prev.spyder.overrideAttrs (oldAttrs: {
    propagatedBuildInputs = with final; oldAttrs.propagatedBuildInputs ++ [
      cookiecutter Rtree qstylizer jellyfish
    ];
  }));

  stdio-mgr = final.callPackage ./stdio-mgr.nix { };

  typish = final.callPackage ./typish.nix { };

  vtk_9 = final.toPythonModule vtk_9_nonpython;

}
