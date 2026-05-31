{
  partitions.development.module = {
    perSystem =
      { config, lib, ... }:
      {
        shellEnvironments.default =
          with config.shellEnvironments;
          lib.mkMerge [
            go
            just
            nix
          ];
      };
  };
}
