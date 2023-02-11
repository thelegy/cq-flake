inputs:
final:
prev:

{

  # keep gcc, llvm and stdenv versions in sync
  gccSet = {
    # have to use gcc9 because freeimage complains with gcc8, could probably build freeimage with gcc8 if I have to, but this is easier.
    llvmPackages = final.llvmPackages_10; # canonical now builds with llvm10: https://github.com/CadQuery/OCP/commit/2ecc243e2011e1ea5c57023dee22e562dacefcdd
    stdenv = final.stdenv; # not currently used, can probably be removed unless I have to control GCC version again in the future
  };

  # I'm quite worried about how I handle this VTK. Python -> VTK (for Python bindings) -> OCCT -> Python(OCP)
  new_vtk_9 = final.libsForQt5.callPackage ./VTK {
    enablePython = true;
    pythonInterpreter = final.pythonCQ;
  };

  opencascade-occt = final.callPackage ./opencascade-occt {
    inherit (final.gccSet) stdenv;
    vtk_9 = final.new_vtk_9;
  };

  nlopt = final.callPackage ./nlopt.nix {
    python = final.pythonCQ;
    pythonPackages = final.pythonCQ.pkgs;
  };

  scotch = prev.scotch.overrideAttrs (oldAttrs: {
    buildFlags = ["scotch ptscotch esmumps ptesmumps"];
    installFlags = ["prefix=\${out} scotch ptscotch esmumps ptesmumps" ];
  } );

  tbb = final.callPackage ./tbb.nix {};

  mumps = final.callPackage ./mumps.nix {
    inherit (final) scotch;
  };

  casadi = final.callPackage ./casadi.nix {
    inherit (final) mumps scotch;
    python = final.pythonCQ;
  };

  py-overrides = import ./python {
    inherit (inputs) llvm-src pywrap-src ocp-src ocp-stubs-src cadquery-src pybind11-stubgen-src;
    inherit (final) gccSet fetchFromGitHub;
    vtk_9_nonpython = final.new_vtk_9;
    occt = final.opencascade-occt;
    nlopt_nonpython = final.nlopt;
    casadi_nonpython = final.casadi;
  };

  pythonCQ = final.python310.override {
    self = final.__splicedPackages.pythonCQ;
    packageOverrides = final.py-overrides;
  };

  pythonCQPackages = final.pythonCQ.pkgs;

  cq-editor = final.libsForQt5.callPackage ./cq-editor.nix {
    python3Packages = final.pythonCQ.pkgs;
    src = inputs.cq-editor-src;
  };

  cq-docs = final.pythonCQ.pkgs.callPackage ./cq-docs.nix {
    src = inputs.cadquery-src;
  };

}
