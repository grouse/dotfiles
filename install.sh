#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# emacs installation
if [ ! -d ~/.emacs.d ];
then
	ln -s "$DOTFILES_DIR/emacs" ~/.emacs.d
fi

# neovim installation
if [ ! -d ~/.config/nvim ];
then
	ln -s "$DOTFILES_DIR/neovim" ~/.config/nvim
fi

# qtcreator installation
if [ ! -d ~/.config/QtProject/qtcreator/styles ];
then
	ln -s "$DOTFILES_DIR/qtcreator/styles" ~/.config/QtProject/qtcreator/styles
fi

