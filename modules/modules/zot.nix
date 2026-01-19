{ lib, ... }:
let
  module =
    { pkgs, ... }:
    {
      options =
        with lib;
        with types;
        {
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
          distSpecVersion = lib.mkDefault "1.1.1";
          http = {
            address = lib.mkDefault "127.0.0.1";
            port = lib.mkDefault 8080;
          };
          extensions = {
            search = {
              enable = lib.mkDefault true;
            };
            ui = {
              enable = lib.mkDefault true;
            };
          };
          log = {
            level = lib.mkDefault "debug";
          };
          storage = {
            rootDirectory = lib.mkDefault "/tmp/zot";
          };
        };
      };
    };
in
{
  flake.modules.zot.module = module;
}
