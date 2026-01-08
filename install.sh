#!/bin/sh

if [ $# -eq 0 ]; then
    echo "Usage: $0 all | [package]..."
    exit 1
fi

DO_INSTALL=1
DO_CONFIG=1

while [ $# -gt 0 ]; do
    case "$1" in
        --config)
            DO_INSTALL=0
            DO_CONFIG=1
            shift
            ;;
        --install)
            DO_INSTALL=1
            DO_CONFIG=0
            shift
            ;;
        all|-p|--package)
            # handled later
            break
            ;;
        *)
            break
            ;;
    esac
done

ROOT="$(cd "$(dirname "$0")"; pwd)"
HOME_DIR="${HOME:-$(getent passwd $(whoami) | cut -d: -f6)}"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME_DIR/.config}"
DATA_DIR="${XDG_DATA_HOME:-$HOME_DIR/.local/share}"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME_DIR/.cache}"

if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    echo "Cannot determine Linux distribution."
    exit 1
fi

case "$DISTRO" in
    fedora)
        PKG_INSTALL="sudo dnf install"
        ;;
    ubuntu)
        PKG_INSTALL="sudo apt install"
        ;;
    *)
        echo "Unsupported distribution: $DISTRO"
        exit 1
        ;;
esac


echo "Detected distribution: $DISTRO"

APP_PACKAGES=""
DEV_PACKAGES="gdb git neovim clang ninja-build meson make pkgconfig cmake"
LIB_PACKAGES=""

case "$DISTRO" in
    fedora)
        LIB_PACKAGES="libX11-devel"
        ;;
esac

PACKAGES=""
if [ "$1" = "all" ]; then
    PACKAGES="profile $DEV_PACKAGES $LIB_PACKAGES $APP_PACKAGES"
    shift
else
    while [ $# -gt 0 ]; do
        case "$1" in
            -p|--package)
                PACKAGES="$PACKAGES $2"
                shift 2
                ;;
            *)
                PACKAGES="$PACKAGES $1"
                shift 1
                ;;
        esac
    done
fi

symlink() {
    TARGET="$1"
    LINK="$2"

    if [ -e "$LINK" ] || [ -L "$LINK" ]; then
        echo "skipping $LINK (already exists)"
    else
        echo "symlink $LINK -> $TARGET"
        ln -s "$TARGET" "$LINK"
    fi
}

git() {
    echo "git $@"
    command git "$@"
}

mkdir -p "$CONFIG_DIR" "$DATA_DIR" "$CACHE_DIR"

SYS_PACKAGES=""
FLAT_PACKAGES=""
SNAP_PACKAGES=""

for PKG in $PACKAGES; do
    case "$PKG" in
        neovim)
            SYS_PACKAGES="$SYS_PACKAGES $PKG wl-clipboard xclip"
            ;;
        *)
            SYS_PACKAGES="$SYS_PACKAGES $PKG"
            ;;
    esac
done

if [ "$DO_INSTALL" -eq 1 ]; then
    echo "$PKG_INSTALL $SYS_PACKAGES"
    $PKG_INSTALL $SYS_PACKAGES
fi

if [ "$DO_CONFIG" -eq 1 ]; then
    for PKG in $PACKAGES; do
        case "$PKG" in
            neovim)
                symlink "$ROOT/neovim" "$CONFIG_DIR/nvim"
                ;;
            gdb)
                symlink "$ROOT/gdbinit" "$HOME_DIR/.gdbinit"
                ;;
            git)
                git config --global user.email "jesper.stefansson@gmail.com"
                git config --global user.name "Jesper Stefansson"
                git config --global merge.tool kdiff3
                git config --global pull.rebase true
                ;;
            profile)
                symlink "$ROOT/shell/profile" "$HOME_DIR/.profile"
                ;;
        esac
    done
fi
