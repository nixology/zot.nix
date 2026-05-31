{ ... }@local:
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
      { ... }@module:
      let
        inherit (local.inputs) flake;
        inherit (module.inputs) environments;

        inherit (flake.lib.components) uses;

        inherit (environments.components) nixology;
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
