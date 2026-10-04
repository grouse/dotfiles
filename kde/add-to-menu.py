#!/usr/bin/env python3
"""Create application-menu launchers, or install the Dolphin context action."""

import argparse
import hashlib
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys


def desktop_value(value):
    return (value.replace("\\", "\\\\").replace("\n", "\\n")
            .replace("\r", "\\r").replace("\t", "\\t"))


def exec_argument(value):
    # Exec quoting is decoded after desktop-value escapes; percent codes are separate.
    value = value.replace("%", "%%")
    for character in ('\\', '"', '`', '$'):
        value = value.replace(character, "\\" + character)
    return desktop_value('"' + value + '"')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("binary", nargs="?", help="path to an executable")
    parser.add_argument("--install", action="store_true", help="install Dolphin action")
    parser.add_argument("--dialog", action="store_true", help="ask for a name using KDialog")
    parser.add_argument("--terminal", action="store_true", help="launch in a terminal")
    args = parser.parse_args()
    data_dir = Path(os.environ.get("XDG_DATA_HOME") or Path.home() / ".local/share")

    if args.install:
        if not shutil.which("kdialog"):
            raise ValueError("Install kdialog first; the Dolphin action uses it for dialogs.")
        helper = data_dir / "dotfiles/add-to-menu.py"
        helper.parent.mkdir(parents=True, exist_ok=True)
        source = Path(__file__).resolve()
        if source != helper.resolve():
            shutil.copyfile(source, helper)
        service = data_dir / "kio/servicemenus/add-to-menu.desktop"
        service.parent.mkdir(parents=True, exist_ok=True)
        service.write_text(
            "[Desktop Entry]\n"
            "Type=Service\n"
            "MimeType=application/x-executable;application/x-pie-executable;"
            "application/x-sharedlib;application/x-shellscript;text/x-shellscript;"
            "application/vnd.appimage;application/x-iso9660-appimage;\n"
            "Actions=addToMenu;\n"
            "X-KDE-Protocol=file\n"
            "X-KDE-RequiredNumberOfUrls=1\n"
            "X-KDE-Priority=TopLevel\n\n"
            "[Desktop Action addToMenu]\n"
            "Name=Add to Application Menu…\n"
            "Icon=application-x-executable\n"
            f"Exec=python3 {exec_argument(str(helper))} --dialog -- %f\n",
            encoding="utf-8",
        )
        service.chmod(0o755)
        print(f"Installed: {service}")
        return 0

    if not args.binary:
        parser.error("provide an executable path, or use --install")
    # Preserve symlinks, so launchers follow the user's chosen path across upgrades.
    binary = Path(os.path.abspath(os.path.expanduser(args.binary)))
    if not binary.is_file() or not os.access(binary, os.X_OK):
        raise ValueError(f"Choose an executable file: {binary}")
    # env interprets '=' as an assignment, even after its option delimiter.
    if "=" in str(binary) or any(ord(character) < 32 for character in str(binary)):
        raise ValueError("Desktop launchers cannot use this executable path; rename it first.")
    name = binary.name
    if args.dialog:
        result = subprocess.run(
            ["kdialog", "--title", "Add to Application Menu", "--inputbox",
             "Application name:", name], capture_output=True, text=True,
        )
        if result.returncode != 0:
            return 0
        name = result.stdout.strip()
        if not name:
            raise ValueError("Enter a non-empty application name.")

    # Include the path so binaries with the same basename get separate launchers.
    slug = re.sub(r"[^a-zA-Z0-9._-]", "-", binary.name)[:48] or "app"
    suffix = hashlib.sha256(os.fsencode(binary)).hexdigest()[:12]
    launcher = data_dir / "applications" / f"local-{slug}-{suffix}.desktop"
    launcher.parent.mkdir(parents=True, exist_ok=True)
    launcher.write_text(
        "[Desktop Entry]\n"
        "Type=Application\n"
        f"Name={desktop_value(name)}\n"
        f"TryExec={desktop_value(str(binary))}\n"
        # Some launchers check executable existence before expanding literal %%.
        f"Exec=/usr/bin/env -- {exec_argument(str(binary))}\n"
        "Icon=application-x-executable\n"
        f"Terminal={'true' if args.terminal else 'false'}\n"
        "Categories=Utility;\n",
        encoding="utf-8",
    )
    print(f"Created: {launcher}")
    if args.dialog:
        subprocess.run(["kdialog", "--passivepopup", "Added to the application menu.", "3"])
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (OSError, ValueError) as error:
        message = f"Could not add application launcher: {error}"
        print(message, file=sys.stderr)
        if "--dialog" in sys.argv and shutil.which("kdialog"):
            subprocess.run(["kdialog", "--error", message])
        sys.exit(1)
