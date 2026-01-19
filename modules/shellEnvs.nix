{
  partitions.development.module = {
    perSystem =
      { config, lib, ... }:
      {
        shellEnvs.default =
          with config.shellEnvs;
          lib.mkMerge [
            go
            just
            nix
          ];
      };
  };
}
