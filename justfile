import 'justfiles/modules.just'

#
# recipes
#

[doc('Builds the zot server.')]
[unix]
build:
    just flake::build zot

[doc('Runs the zot server.')]
[unix]
run:
    nix run .#zot

@update:
    nix flake update --flake `dirname {{ justfile() }}`
    nix flake update --flake `dirname {{ justfile() }}`/partitions/development

# #####################################################################
[default]
_:
    just ui

#
# settings
#

set shell := ["bash", "-uc"]
set quiet := true

export EXTRA_DEBUG_TEXT := '''
  built binaries are in $GOPATH/bin
'''
