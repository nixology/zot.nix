local@{ ... }:
let
  partition = "development";
in
{
  partitionedAttrs = {
    checks = partition;
    devShells = partition;
    formatter = partition;
  };

  partitions.${partition} = {
    extraInputsFlake = ../partitions/${partition};

    module =
      module@{ ... }:
      let
        inherit (local.inputs.flake.lib.components) uses;
        inherit (module.inputs.environments.components) nixology;
      in
      uses {
        components = [
          nixology.environments.bash
          nixology.environments.go
          nixology.environments.just
          nixology.environments.nix
        ];
      };
  };
}
