{ inputs, ... }:
let
  module = {
    imports =
      with inputs.flake.components;
      map (component: component.module) [
        nixology.extra.shellEnvs
        nixology.flake.modules
        nixology.flake.packages
        nixology.core.components
        nixology.core.debug
        nixology.core.lib
        nixology.core.partitions
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
            nixology.environments.nix
          ];
      };
  };
in
module
