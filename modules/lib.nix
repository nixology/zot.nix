{ inputs, lib, ... }:
let
  library = {
    mkZotConfig =
      {
        modules ? [ ],
        pkgs,
        ...
      }:
      let
        json = pkgs.formats.json { };
        configuration = lib.evalModules {
          specialArgs = { inherit pkgs; };
          modules = modules ++ [
            inputs.self.modules.zot.module
          ];
        };
      in
      json.generate "config.json" configuration.config.settings;
  };

  module = {
    flake.lib = library;
  };

  component = {
    inherit module;
  };
in
{
  imports = [ module ];
  flake.components = {
    nixology.zot.lib = component;
  };
}
