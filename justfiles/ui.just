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
[doc('Displays an interactive menu to choose a tool.')]
[no-cd]
[unix]
_menu MODULE="":
    #!/usr/bin/env bash
    set -euo pipefail

    RECIPES=$(just --summary | xargs -n1 | grep "{{ MODULE }}")
    MENU=$(echo "$RECIPES" | \
      { echo "{{ TITLE }}Development Environment Toolkit{{ RESET }}"; echo "{{ WARNING }}ESC to exit{{ RESET }}"; echo; cat; } )
    just --choose --chooser="echo '$MENU' | \
      fzf --ansi --header-lines=3 --reverse --no-sort --prompt='Task: ' --height 30% --preview 'just --show {}' \
      || echo 'ui::_exit'"

[doc('Exits the menu without choosing any tool.')]
[no-cd]
[unix]
_exit:
    @exit 0

# vim: set ft=just :
