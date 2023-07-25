#!/usr/bin/env python3
import argparse
import os
from sys import platform

parser = argparse.ArgumentParser("install.py", description="installs user configuration and environment")
parser.add_argument("-c", "--configure", choices=["all", "neovim"], help="install configuration files for specified application")
args = parser.parse_args();

root = os.path.dirname(os.path.abspath(__file__))


if platform == "win32":
    local_config = os.path.realpath(os.path.expandvars("%appdata%/../local"))
elif platform == "linux":
    local_config = os.path.realpath(os.path.expandvars("$HOME/.config/"))
    if not os.path.exists(local_config):
        mkdir(local_config)
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
    symlink("{}/nvim".format(local_config), "{}/neovim".format(root));
        
