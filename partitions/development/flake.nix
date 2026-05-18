{
  description = "private inputs for development purposes.";

  # this flake is only used for its inputs
  outputs = { ... }: { };

  inputs.environments.url = "github:nixology/environments.nix";
}
