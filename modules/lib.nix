{ ... }@local:
let
  inherit (local.inputs) flake self;

  inherit (local.lib)
    evalModules
    recursiveUpdate
    ;

  inherit (recursiveUpdate flake.components self.components) nixology;

  library = {
    mkZotConfig =
      {
        modules ? [ ],
        pkgs,
        ...
      }:
      let
        json = pkgs.formats.json { };
        configuration = evalModules {
          specialArgs = { inherit pkgs; };
          modules = modules ++ [
            local.inputs.self.modules.zot.module
          ];
        };
      in
      json.generate "config.json" configuration.config.settings;
  };

  implementation = {
    flake.lib = library;
  };

  check = {
    perSystem =
      { pkgs, ... }:
      let
        evalZotLib = local.inputs.flake.lib.evalComponent { inherit (local) inputs; } nixology.zot.lib;
      in
      {
        checks.zot-lib-component = pkgs.runCommandLocal "zot-lib-component-check" { } ''
          : ${builtins.seq evalZotLib.config "ok"}
          : ${builtins.seq evalZotLib.config.flake.lib.mkZotConfig "ok"}
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
    nixology.zot.lib = {
      inherit implementation;

      dependencies = [
        nixology.core.flake
      ];
    };
  };
}
