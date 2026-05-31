{ ... }@local:
let
  inherit (local.inputs) flake self;

  inherit (local.lib) recursiveUpdate;

  inherit (recursiveUpdate flake.components self.components) nixology;

  implementation = {
    perSystem =
      { pkgs, ... }:
      {
        packages.zui = pkgs.buildNpmPackage {
          pname = "zui";
          version = local.inputs.ZUI.shortRev;
          src = local.inputs.ZUI;

          npmDepsHash = "sha256-hmE03WczgD4wg2RnEETbyA6nEYlLZMxMctIbQ2onptY=";

          installPhase = ''
            mkdir $out
            cp -R build $out
          '';
        };
      };
  };

  check = {
    perSystem =
      { pkgs, ... }:
      let
        evalZui = local.inputs.flake.lib.evalComponent { inherit (local) inputs; } nixology.zot.zui;
      in
      {
        checks.zui-component = pkgs.runCommandLocal "zui-component-check" { } ''
          : ${builtins.seq evalZui.config "ok"}
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
    nixology.zot.zui = {
      inherit implementation;

      dependencies = [
        nixology.core.perSystem
      ];
    };
  };
}
