{
  description = "A scale-out production-ready vendor-neutral OCI-native container image/artifact registry";

  inputs = {
    ZOT.url = "github:project-zot/zot";
    ZOT.flake = false;

    ZUI.url = "github:project-zot/zui";
    ZUI.flake = false;
  };

  inputs.flake.url = "git+ssh://git@github.com/marksisson/flake";

  outputs =
    inputs: with inputs.flake.lib; mkFlake { inherit inputs; } { imports = modulesIn ./modules; };
}
