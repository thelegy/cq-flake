{ buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage {
  name = "apply_to_each_face";
  src = fetchFromGitHub {
    owner = "CadQuery";
    repo = "cadquery-plugins";
    rev = "c3ac483f666dd87ab18acf21800f7c0047da0d82";
    hash = "sha256-FL5LEIiGQS0zMhfe6CXKch3bmDQdK3U5J273hRf31Ak=";
  };
  postPatch = "cd plugins/apply_to_each_face";
  doCheck = false;
}
