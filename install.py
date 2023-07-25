#!/usr/bin/env python3
import argparse
import os
from sys import platform

parser = argparse.ArgumentParser("install.py", description="installs user configuration and environment")
parser.add_argument("-c", "--configure", choices=["all", "neovim"], help="install configuration files for specified application")
args = parser.parse_args();

root = os.path.dirname(os.path.abspath(__file__))
local_config = os.path.realpath(os.path.expandvars("%appdata%/../local"));

def symlink(path, target):
    if platform == "win32":
        path = os.path.abspath(path)
        target = os.path.abspath(target)

        os.system("mklink /J {} {}".format(path, target))

if args.configure == "all" or args.configure == "neovim":
    symlink("{}/nvim".format(local_config), "{}/neovim".format(root));
        