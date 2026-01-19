#
# Justfile for Nix flake development environment toolkit
#

set shell := ["bash", "-uc"]
set quiet := true

mod ui

#
# variables
#

DEBUG_TEXT := '''
  see: nix develop --help
  see: https://nixos.wiki/wiki/Nixpkgs/Create_and_debug_packages

  - pushd $(mktemp -d)

  - runPhase unpackPhase
  - runPhase patchPhase
  - runPhase configurePhase
  - runPhase buildPhase
  - runPhase installPhase
  - runPhase fixupPhase
  - runPhase checkPhase
  - runPhase installCheckPhase
  - runPhase distPhase
'''
ENVRC := '''
  #
  # "use flake" watches flake.nix and flake.lock automatically
  # watch_file must be invoked before "use flake"
  #
  watch_file justfile
  watch_dir justfiles
  watch_dir modules

  use flake .# --option sandbox false
'''
RESET := `tput sgr0`
TITLE := `tput bold; tput setaf 4`
WARNING := `tput sitm; tput setaf 9`

#
# recipes
#

# #####################################################################
[default]
[no-cd]
_:
    just ui _menu flake

[doc('Sets up direnv for the flake environment.')]
[no-cd]
[unix]
bootstrap:
    echo '{{ ENVRC }}' > .envrc

[doc('Builds default package defined in the flake.')]
[no-cd]
[unix]
build PACKAGE="default":
    nom build .#{{ PACKAGE }}

[doc('Runs default app or package defined in the flake.')]
[no-cd]
[unix]
run:
    nix run

[doc('Debugs a package build defined in the flake.')]
[no-cd]
[unix]
debug PACKAGE="":
    #!/usr/bin/env bash
    set -euo pipefail

    pkg="{{ PACKAGE }}"

    if [ -z "$pkg" ]; then
      echo "{{ TITLE }}Select a package to debug{{ RESET }}"
      system=$(nix eval --impure --raw --expr builtins.currentSystem)
      pkg=$(
        nix flake show . --json 2>/dev/null | \
        jq -r --arg system "$system" '.packages[$system] | keys[]' | \
        grep -v default | \
        (fzf --reverse --prompt='Package: ' --height 30% || :)
      )
      [ -z "$pkg" ] && echo "No package selected, exiting." && exit 0;
    fi

    echo "{{ WARNING }}Debugging package: $pkg{{ RESET }}"
    echo
    echo '{{ DEBUG_TEXT }}'
    echo "$EXTRA_DEBUG_TEXT"
    nom develop .#${pkg}

[doc('Updates the flake inputs and reloads direnv.')]
[no-cd]
[unix]
update INPUT="":
    #!/usr/bin/env bash
    set -euo pipefail

    input="{{ INPUT }}"

    if [ -z "$input" ]; then
      echo "{{ TITLE }}Select an input to update (ESC to update all inputs){{ RESET }}"
      input=$(
        nix flake metadata . --json 2>/dev/null | \
        jq '.locks.nodes.root.inputs[]' | sed "s/\"//g" | \
        (fzf --reverse --prompt='Input: ' --height 30% || :)
      )
    fi

    if [ -z "$input" ]; then
      echo "Updating all inputs..."
      nix flake update
    else
      echo "Updating input: $input"
      nix flake update "$input"
    fi

    direnv reload

# vim: set ft=just :
