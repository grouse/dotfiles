#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function prepend {
	TMP_FILE=mktmp
	printf "$1" | cat - $2 > $TMP_FILE && mv $TMP_FILE $2 
}

# emacs installation
EMACS_LINES="; load root configuration from https://github.com/grouse/dotfiles"
EMACS_LINES="$EMACS_LINES\n(load-file \"$DOTFILES_DIR/emacs/init.el\")\n\n"
prepend "$EMACS_LINES" "$HOME/.emacs.d/init.el"
