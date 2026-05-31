local@{ ... }:
let
  nixology = local.inputs.self.components.nixology // local.inputs.flake.components.nixology;

  implementation = {
    perSystem =
      { pkgs, ... }:
      {
        packages.zui = pkgs.buildNpmPackage {
          pname = "zui";
          version = local.inputs.ZUI.shortRev;
          src = local.inputs.ZUI;

          npmDepsHash = "sha256-j7mbF9bLaT9Vwv+0PbSKi7hFcFbBNeyHaqGSENrpg4s=";

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
