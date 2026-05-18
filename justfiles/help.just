#
# Justfile for Nix flake development environment toolkit
#

set shell := ["bash", "-uc"]
set quiet

#
# variables
#

RESET := `tput sgr0`
TITLE := `tput bold; tput setaf 4`
WARNING := `tput sitm; tput setaf 9`

#
# recipes
#

[default]
[doc('Displays help for a just module.')]
[no-cd]
module MODULE="":
    #!/usr/bin/env bash

    warn_text="{{ WARNING }}⚠ .envrc not found – run 'just bootstrap' first!{{ RESET }}"
    [[ -f .envrc ]] && warn_text="$(tput cuu 1)"

    heading="
      ${warn_text}
      {{ TITLE }}Development Environment Toolkit{{ RESET }}
    "

    [ -n "{{ MODULE }}" ] && heading+="
      {{ TITLE }}Module:{{ RESET }} {{ MODULE }}
    "

    heading+="
    "

    just --list {{ MODULE }} --list-heading "$heading" --list-submodules --justfile {{ justfile() }}

# vim: set ft=just :
