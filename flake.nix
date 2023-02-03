{
  description = "CQ-editor and CadQuery";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    flake-utils.url = "github:numtide/flake-utils";
    cadquery-src = {
      url = "github:CadQuery/cadquery/2.2.0";
      flake = false;
    };
    cq-editor-src = {
      url = "github:CadQuery/CQ-editor/adf11592c96c2d8490e1e8d332d1a9bb63f5c112";
      flake = false;
    };
    ocp-stubs-src = {
      url = "github:cadquery/ocp-stubs";
      flake = false;
    };
    pywrap-src = {
      url = "github:CadQuery/pywrap";
      flake = false;
    };
    llvm-src = {
      url = "github:llvm/llvm-project/llvmorg-10.0.1";
      flake = false;
    };
    pybind11-stubgen-src = {
      url = "github:CadQuery/pybind11-stubgen";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... } @ inputs:
    let

      # someone else who can do the testing might want to extend this to other systems
      systems = [ "x86_64-linux" ];

      overlay = import ./expressions/overlay.nix inputs;

    in
      (flake-utils.lib.eachSystem systems ( system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ overlay ];
          };
        in rec {
          packages = {
            cadquery-env-minimal = pkgs.pythonCQ.withPackages (
              ps: with ps; [ cadquery cq-kit ocp-stubs pybind11-stubgen ]
            );
            cadquery-env = pkgs.pythonCQ.withPackages (
              ps: with ps; [ cadquery cq-kit black mypy ocp-stubs pytest pytest-xdist pytest-cov pytest-flakefinder pybind11-stubgen ]
            );
            just-ocp = pkgs.pythonCQ.withPackages ( ps: with ps; [ ocp ] );
            # cadquery-dev-shell = packages.python38.withPackages (
            #   ps: with ps; ([ black mypy ocp-stubs ]
            #   ++ cadquery.propagatedBuildInputs
            #   # I have no idea why, but I can't access checkInputs
            #   # ++ cadquery.checkInputs
            #   ++ [ pytest ]
            #   ++ cadquery.nativeBuildInputs
            # ));
            inherit (pkgs) cq-editor cq-docs mumps opencascade-occt;
            python = pkgs.pythonCQ;

            default = packages.cq-editor;
          };

          apps.default = flake-utils.lib.mkApp { drv = packages.default; };
          # TODO: add dev env for cadquery
          # devShell = packages.cadquery-dev-shell;
          # TODO: add dev env for cq-editor, with hopefully working pyqt5
        }
      )) // {
        overlays.default = overlay;
      };
}
