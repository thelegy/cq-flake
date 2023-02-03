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

  cymbal = final.callPackage ./cymbal.nix { };

  casadi = final.toPythonModule casadi_nonpython;

  dictdiffer = final.callPackage ./dictdiffer.nix { };

  geomdl = final.callPackage ./geomdl.nix { };

  ezdxf = final.callPackage ./ezdxf.nix { };

  sphinx = final.callPackage ./sphinx.nix { };

  nptyping = final.callPackage ./nptyping { };

  typish = final.callPackage ./typish.nix { };

  sphinx-autodoc-typehints = final.callPackage ./sphinx-autodoc-typehints.nix { };

  sphobjinv = final.callPackage ./sphobjinv.nix { };

  stdio-mgr = final.callPackage ./stdio-mgr.nix { };

  sphinx-issues = final.callPackage ./sphinx-issues.nix { };

  sphinxcadquery = final.callPackage ./sphinxcadquery.nix { };

  pywrap = final.callPackage ./pywrap {
    src = pywrap-src;
    inherit (gccSet) llvmPackages;
  };

  pytest-flakefinder = final.callPackage ./pytest-flakefinder.nix { };

  ocp = final.callPackage ./OCP {
    inherit (gccSet) stdenv llvmPackages;
    opencascade-occt = occt;
  };

  ocp-stubs = final.callPackage ./OCP/stubs.nix {
    src = ocp-stubs-src;
  };

  cadquery = final.callPackage ./cadquery.nix {
    src = cadquery-src;
  };

  cadquery_w_docs = final.callPackage ./cadquery.nix {
    documentation = true;
    src = cadquery-src;
  };

  vtk_9 = final.toPythonModule vtk_9_nonpython;

  nlopt = final.toPythonModule nlopt_nonpython;

  pybind11-stubgen = final.callPackage ./OCP/pybind11-stubgen.nix {
    src = pybind11-stubgen-src;
  };

  qdarkstyle = (prev.qdarkstyle.overrideAttrs (oldAttrs: rec {
    version = "3.0.2";
    src = final.fetchPypi {
      inherit version;
      pname = "QDarkStyle";
      sha256 = "sha256-VdFJz19A7ilzl/GBjgkRGM77hVpKnFw4VmxHrNLYx64=";
    };
  }));

  spyder = (prev.spyder.overrideAttrs (oldAttrs: {
    propagatedBuildInputs = with final; oldAttrs.propagatedBuildInputs ++ [
      cookiecutter Rtree qstylizer jellyfish
    ];
  }));

  qstylizer = final.callPackage ./qstylizer.nix { };

  python-language-server = prev.python-language-server.overrideAttrs (oldAttrs: { 
    # TODO: diagnose what's going on here and if I can replace python-language-server since:
    # https://github.com/palantir/python-language-server/pull/918#issuecomment-817361554
    meta.broken = false;
    disabledTests = oldAttrs.disabledTests ++ [
      "test_lint_free_pylint"
      "test_per_file_caching"
      "test_multistatement_snippet"
      "test_jedi_completion_with_fuzzy_enabled"
      "test_jedi_completion"
    ];
  });

  multimethod = final.callPackage ./multimethod.nix { };

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

  # joblib = prev.joblib.overridePythonAttrs (oldAttrs: {
  #   checkInputs = [];
  #   doCheck = false;
  # });

  jinja2 = prev.jinja2.overridePythonAttrs (oldAttrs: rec {
    version = "3.0.3";
    src = final.fetchPypi {
      inherit (oldAttrs) pname;
      inherit version;
      sha256 = "611bb273cd68f3b993fabdc4064fc858c5b47a973cb5aa7999ec1ba405c87cd7";
    };
  });

  cq-kit = final.callPackage ./cq-kit {};

}
