#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# emacs installation
ln -s "$DOTFILES_DIR/emacs" ~/.emacs.d

# qtcreator installation
ln "$DOTFILES_DIR/qtcreator/styles/wombat-style.xml" ~/.config/QtProject/qtcreator/styles/wombat-style.xml
