{ ... }@local:
let
  inherit (local.inputs) flake self;

  inherit (local.lib) recursiveUpdate;

  inherit (recursiveUpdate flake.components self.components) nixology;

  implementation = {
    perSystem =
      { pkgs, self', ... }:
      let
        config-json = self.lib.mkZotConfig { inherit pkgs; };
      in
      {
        packages.zot-wrapper = pkgs.writeShellScriptBin "zot" ''
          exec ${self'.packages.zot}/bin/zot serve ${config-json}
        '';
      };
  };

  check = {
    perSystem =
      { pkgs, ... }:
      let
        evalZotWrapper = flake.lib.evalComponent {
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
