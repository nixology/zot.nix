local@{ ... }:
let
  nixology = local.inputs.self.components.nixology // local.inputs.flake.components.nixology;

  implementation = {
    perSystem =
      { pkgs, system, ... }:
      let
        config-json = local.inputs.self.lib.mkZotConfig { inherit pkgs; };
      in
      {
        packages.zot-wrapper = pkgs.writeShellScriptBin "zot" ''
          exec ${local.inputs.self.packages.${system}.zot}/bin/zot serve ${config-json}
        '';
      };
  };

  check = {
    perSystem =
      { pkgs, ... }:
      let
        evalZotWrapper = local.inputs.flake.lib.evalComponent {
          inherit (local) inputs;
        } nixology.zot.zot-wrapper;
      in
      {
        checks.zot-wrapper-component = pkgs.runCommandLocal "zot-wrapper-component-check" { } ''
          : ${builtins.seq evalZotWrapper.config "ok"}
          touch "$out"
        '';
      };
  };
in
{
  imports = [
    check
    implementation
  ];

  flake.components = {
    nixology.zot.zot-wrapper = {
      inherit implementation;

      dependencies = [
        nixology.core.flake
        nixology.core.perSystem
      ];

      meta = {
        description = ''
          A wrapper around the Zot OCI registry that serves with a pre-generated
          configuration, allowing you to start a Zot registry with a single command.
        '';
        shortDescription = "Zot with a built-in configuration";
      };
    };
  };
}
