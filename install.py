#!/usr/bin/env python3
import argparse
import os
from sys import platform

parser = argparse.ArgumentParser("install.py", description="installs user configuration and environment")
parser.add_argument("-c", "--configure", choices=["all", "neovim"], help="install configuration files for specified application")
parser.add_argument("-i", "--install", choices=["all", "deps"], help="install application(s)")
args = parser.parse_args();

root = os.path.dirname(os.path.abspath(__file__))

if platform == "win32":
    config = os.path.realpath(os.path.expandvars("%appdata%/../local"))
elif platform == "linux":
    home = os.path.realpath(os.path.expandvars("$HOME"))
    config = os.path.realpath(os.path.expandvars("$HOME/.config/"))
    if not os.path.exists(config):
        mkdir(config)
else:
    print("unknown platform: {}".format(platform))

def symlink(path, target):
    path = os.path.abspath(path)
    target = os.path.abspath(target)

    if platform == "win32":
        os.system("mklink /J {} {}".format(path, target))
    elif platform == "linux":
        os.system("ln -s {} {}".format(target, path))

if args.configure == "all" or args.configure == "neovim":
    symlink("{}/nvim".format(config), "{}/neovim".format(root));

if args.configure == "all":
    if platform == "linux":
        symlink("{}/.gdbinit".format(home), "{}/gdbinit".format(root))
        symlink("{}/gf2_config.ini".format(config), "{}/gf2_config.ini".format(root))

if args.install == "all" or args.install == "deps":
    if platform == "linux":
        os.system("sudo apt install clang ninja-build make")
        os.system("sudo apt install fzf ripgrep")
        os.system("sudo apt install libx11-dev libxi-dev libglx-dev")
        os.system("sudo snap install --classic cmake")
        os.system("sudo snap install --classic node")

if args.install == "all" or args.install == "neovim":
    if platform == "linux":
        os.system("sudo snap install --classic nvim")
        os.system("sudo apt install wl-clipboard xclip")
