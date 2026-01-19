{
  description = "private inputs for development purposes.";

  # this flake is only used for its inputs
  outputs = { ... }: { };

  # used for locking and following dependencies; do not access from parent flake
  inputs.main.url = "path:../..";

  inputs.environments = {
    url = "git+ssh://git@github.com/marksisson/environments";
    inputs.parts.follows = "main/parts";
  };
}
