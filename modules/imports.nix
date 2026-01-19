{ inputs, ... }:
let
  module = {
    imports =
      with inputs.flake.components;
      map (component: component.module) [
        nixology.extra.shellEnvs
        nixology.flake.modules
        nixology.flake.packages
        nixology.std.components
        nixology.std.debug
        nixology.std.lib
        nixology.std.partitions
        nixology.tools.treefmt
      ];

    partitions.development.module =
      { inputs, ... }:
      {
        imports =
          with inputs.environments.components;
          map (component: component.module) [
            nixology.environments.bash
            nixology.environments.go
            nixology.environments.just
          ];
      };
  };
in
module
