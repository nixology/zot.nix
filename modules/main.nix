local@{ ... }:
let
  inherit (local.inputs.flake.lib.components) uses;
  inherit (local.inputs.flake.components) nixology;
in
uses {
  components = [
    nixology.core.components
    nixology.core.lib
    nixology.core.partitions
    nixology.extra.shellEnvs
    nixology.flake.modules
    nixology.flake.packages
    nixology.tools.treefmt
  ];
}
