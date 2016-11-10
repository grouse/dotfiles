#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CONFIGURATIONS=(emacs neovim qtcreator zsh shell)
DISTRIBUTIONS=(ubuntu arch)

function eval_print {
	echo "$1"
	eval $1
}

function array_contains_str {
	local e
	for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 1; done
	return 0
}

function print_usage_exit {
	echo "Usage: install.sh [options]"
	echo ""
	echo "Options:"
	echo "  -h, --help                       Display this information"
	echo "  -p, --packages  DISTRIBUTION     Install the distribution packages for the specified distribution"
	echo "  -c, --configure {all|PACKAGE}    Install the configuration file for the specified package(s)"
	echo ""
	exit
}


function install_packages_arch {
	echo "-- installing system packages for Arch Linux"
	# TODO(jesper): implement!
}

function install_packages_ubuntu {
	echo "-- installing system packages for Ubuntu"
	# TODO(jesper): implement!
}

# configuration installation functions
function install_config_emacs {
	if [[ ! -d ~/.emacs.d ]]; then
		echo "-- installing emacs configuration"
		eval_print "ln -s \"$DOTFILES_DIR/emacs\" ~/.emacs.d"
	else
		echo "-- emacs configuration already installed"
	fi
}

function install_config_neovim {
	if [[ ! -d ~/.config/nvim ]]; then
		echo "-- installing neovim configuration"
		eval_print "ln -s \"$DOTFILES_DIR/neovim\" ~/.config/nvim"
	else
		echo "-- neovim configuration already installed"
	fi
}

function install_config_qtcreator {
	if [[ ! -d ~/.config/QtProject/qtcreator/styles ]]; then
		echo "-- installing qtcreator configuration"
		eval_print "ln -s \"$DOTFILES_DIR/qtcreator/styles\" ~/.config/QtProject/qtcreator/styles"
	else
		echo "-- qtcreator configuration already installed"
	fi
}

function install_config_shell {
	if [[ ! -d ~/.config/shell ]]; then
		echo "-- installing shell configuration"
		eval_print "ln -s \"$DOTFILES_DIR/shell\" ~/.config/shell"
	else
		echo "-- shell configuration already installed"
	fi
}

function install_config_zsh {
	if [[ ! -d ~/.config/zsh ]]; then
		echo "-- installing zsh configuration"
		eval_print "ln -s \"$DOTFILES_DIR/zsh\" ~/.config/zsh"
	else
		echo "-- zsh configuration already installed"
	fi
}
		
if [[ $# -eq 0 ]]; then
	print_usage_exit
fi

# process arguments
while [[ $# -ge 1 ]]
do
	case "$1" in
	-p|--packages)
		# TODO(jesper): get the distribution from a system call
		array_contains_str "$2" "${DISTRIBUTIONS[@]}"
		if [[ $? -eq 1 ]]; then
			eval "install_packages_$2"
		else
			echo "Unknown distribution to install packages for: $2"
			echo "Available distributions:"
			for i in ${DISTRIBUTIONS[@]}; do
				echo "    ${i}"
			done
		fi
		shift # past argument
	;;
	-c|--configure)
		if [[ $2 == "all" ]]; then
			for i in ${CONFIGURATIONS[@]}; do
				eval "install_config_${i}"
			done
		else
			array_contains_str "$2" "${CONFIGURATIONS[@]}"
			if [[ $? -eq 1 ]]; then
				eval "install_config_$2"
			else
				echo "Unknown configuration to install: $2"
				echo "Available configurations:"
				for i in ${CONFIGURATIONS[@]}; do
					echo "    ${i}"
				done
			fi
		fi
		shift
	;;
	-h|--help)
		print_usage_exit
	;;
	*)
		echo "Unknown option"
		print_usage_exit
	;;
	esac

	shift # past argument or value
done

