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

          npmDepsHash = "sha256-O01OtR3SJ69ScMLgkqVCNx7MGJ5HmXTn22M/zRcZMkg=";

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
