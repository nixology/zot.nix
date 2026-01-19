let
  partition = "development";

  module = {
    partitionedAttrs = {
      checks = partition;
      devShells = partition;
      formatter = partition;
    };

    partitions.${partition}.extraInputsFlake = ../partitions/${partition};
  };
in
module
