{ inputs, ... }:
let
  module = {
    perSystem =
      { pkgs, ... }:
      {
        packages.zui = pkgs.buildNpmPackage {
          pname = "zui";
          version = inputs.ZUI.shortRev;
          src = inputs.ZUI;

          npmDepsHash = "sha256-TI/e5aDe4Lv5SXbQ/9LCAzwR13z8Wrm7m16+1E3Shp8=";

          installPhase = ''
            mkdir $out
            cp -R build $out
          '';
        };
      };
  };

  component = {
    inherit module;
    dependencies = with inputs.parts.components; [
      nixology.parts.systems
    ];
  };
in
{
  imports = [ module ];
  flake.components = {
    nixology.zot.zui = component;
  };
}
