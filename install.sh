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
echo "Detected distribution: $DISTRO"

FLAT_INSTALL="flatpak install"
case "$DISTRO" in
    fedora)
        SYS_INSTALL="sudo dnf install"
        ;;
    ubuntu)
        SYS_INSTALL="sudo apt install"
        ;;
    *)
        echo "Unsupported distribution: $DISTRO"
        exit 1
        ;;
esac

PACKAGES="gdb git neovim code clang unity godot bitwarden meld"
PACKAGES="$PACKAGES cmake make ninja-build meson pkgconfig"
LIBS="libX11-devel libXi-devel"
if [ "$1" = "all" ]; then
    PACKAGES="$LIBS $PACKAGES"
    shift
else
    PACKAGES=""
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
    echo "ln -f -s $@"
    ln -f -s $@
}

git() {
    echo "git $@"
    command git "$@"
}

mkdir -p "$CONFIG_DIR" "$DATA_DIR" "$CACHE_DIR"

case "$DISTRO" in
    fedora)
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
        echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

        sudo sh -c 'echo -e "[unityhub]\nname=Unity Hub\nbaseurl=https://hub.unity3d.com/linux/repos/rpm/stable\nenabled=1\ngpgcheck=1\ngpgkey=https://hub.unity3d.com/linux/repos/rpm/stable/repodata/repomd.xml.key\nrepo_gpgcheck=1" > /etc/yum.repos.d/unityhub.repo'

        sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
        sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
        ;;
esac

if [ "$DO_INSTALL" -eq 1 ]; then
    SYS_PACKAGES=""
    FLAT_PACKAGES=""
    PIP_PACKAGES=""

    for PKG in $PACKAGES; do
        case "$PKG" in
            neovim)
                SYS_PACKAGES="$SYS_PACKAGES $PKG wl-clipboard xclip"
                ;;
            unity)
                SYS_PACKAGES="$SYS_PACKAGES unityhub dotnet-runtime-10.0 dotnet-sdk-10.0"
                ;;
            git)
                SYS_PACKAGES="$SYS_PACKAGES git git-lfs"
                ;;
            godot)
                SYS_PACKAGES="$SYS_PACKAGES scons pkgconfig gcc-c++ libstdc++-static wayland-devel"
                PIP_PACKAGES="$PIP_PACKAGES compiledb"
                ;;
            bitwarden)
                FLAT_PACKAGES="$FLAT_PACKAGES com.bitwarden.desktop"
                ;;
            *)
                SYS_PACKAGES="$SYS_PACKAGES $PKG"
                ;;
        esac
    done

    if [ ! -z "$SYS_PACKAGES" ]; then
        echo "$SYS_INSTALL $SYS_PACKAGES"
        $SYS_INSTALL $SYS_PACKAGES
    fi

    sudo dnf swap ffmpeg-free ffmpeg --allowerasing

    if [ ! -z "$FLAT_PACKAGES" ]; then
        echo "$FLAT_INSTALL $FLAT_PACKAGES"
        $FLAT_INSTALL $FLAT_PACKAGES
    fi

    if [ -z "$PIP_PACKAGES" ]; then
        echo "pip install $PIP_PACKAGES"
        pip install $PIP_PACKAGES
    fi
fi


if [ "$DO_CONFIG" -eq 1 ]; then
    symlink "$ROOT/shell/profile" "$HOME_DIR/.profile"

    for PKG in $PACKAGES; do
        case "$PKG" in
            neovim)
                symlink "$ROOT/neovim" "$CONFIG_DIR/nvim"
                ;;
            gdb)
                symlink "$ROOT/gdbinit" "$HOME_DIR/.gdbinit"
                ;;
            git)
                git config --global merge.tool meld
                git config --global pull.rebase true
                git config --global init.defaultBranch "main"
                git config --global url."ssh://git@".insteadOf https://
                ;;
        esac
    done
fi
