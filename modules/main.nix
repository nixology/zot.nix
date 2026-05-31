{ ... }@local:
let
  inherit (local.inputs) flake;

  inherit (flake.lib.components) uses;
  inherit (flake.components) nixology;
in
uses {
  components = [
    nixology.core.components
    nixology.core.lib
    nixology.core.partitions
    nixology.extra.shellEnvironments
    nixology.flake.modules
    nixology.flake.packages
    nixology.tools.treefmt
  ];
}
