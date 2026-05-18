{
  description = "A scale-out production-ready vendor-neutral OCI-native container image/artifact registry";

  inputs = {
    ZOT.url = "github:project-zot/zot/v2.1.17";
    ZOT.flake = false;

    ZUI.url = "github:project-zot/zui";
    ZUI.flake = false;
  };

  inputs.flake.url = "github:nixology/flake.nix";

  outputs =
    inputs: with inputs.flake.lib; mkFlake { inherit inputs; } { imports = modulesIn ./modules; };
}
