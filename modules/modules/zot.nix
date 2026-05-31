{ ... }@local:
let
  inherit (local.lib)
    mkDefault
    mkOption
    types
    ;

  inherit (types) submodule;

  module =
    { pkgs, ... }:
    {
      options = {
        settings = mkOption {
          type = submodule { freeformType = (pkgs.formats.json { }).type; };
          default = { };
          description = ''
            Configuration for Zot, see
            <link xlink:href="https://zotregistry.dev/admin-guide/admin-guide/#configuration-file"/>
            for supported values.
          '';
        };
      };

      config = {
        settings = {
          distSpecVersion = mkDefault "1.1.1";
          http = {
            address = mkDefault "127.0.0.1";
            port = mkDefault 8080;
          };
          extensions = {
            search = {
              enable = mkDefault true;
            };
            ui = {
              enable = mkDefault true;
            };
          };
          log = {
            level = mkDefault "debug";
          };
          storage = {
            rootDirectory = mkDefault "/tmp/zot";
          };
        };
      };
    };
in
{
  flake.modules.zot.module = module;
}
