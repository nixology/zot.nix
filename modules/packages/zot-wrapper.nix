{ inputs, ... }:
let
  module = {
    perSystem =
      { pkgs, system, ... }:
      let
        config-json = inputs.self.lib.mkZotConfig { inherit pkgs; };
      in
      {
        packages.zot-wrapper = pkgs.writeShellScriptBin "zot" ''
          exec ${inputs.self.packages.${system}.zot}/bin/zot serve ${config-json}
        '';
      };
  };

  component = {
    inherit module;
    dependencies =
      (with inputs.self.components; [
        nixology.zot.lib
      ])
      ++ (with inputs.parts.components; [
        nixology.parts.systems
      ]);
  };
in
{
  imports = [ module ];
  flake.components = {
    nixology.zot.zot-wrapper = component;
  };
}
