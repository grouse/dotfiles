# Add binaries to KDE's application menu

The Linux dotfiles installer includes this utility with `./install.sh all`.
To install just this utility and its dependencies:

```sh
./install.sh add-to-menu
```

To refresh the context action without installing packages (requires Python 3 and
KDialog):

```sh
./install.sh --config add-to-menu
```

You can also install the action directly:

```sh
python3 kde/add-to-menu.py --install
```

Right-click an executable in Dolphin, choose **Add to Application Menu…**, and
enter its display name. You can then find it in the application menu or KRunner.
If the action does not appear, reopen Dolphin and check **Settings → Configure
Dolphin → Context Menu**.

For existing binaries, you can also create launchers directly:

```sh
python3 kde/add-to-menu.py ~/bin/my-app
python3 kde/add-to-menu.py --terminal ~/bin/my-cli-tool
```

Launchers are saved in `~/.local/share/applications/`, respecting `XDG_DATA_HOME`.
Running the action again for the same path updates its launcher. The binary stays
where it is; moving it requires recreating the launcher and deleting the old one.
Files must already be executable (`chmod +x ~/bin/my-app` if needed).

To change an icon, enable a terminal, or remove an entry, use KDE's menu editor
(right-click the application-menu button → **Edit Applications…**). The default
icon is generic, and launchers created from Dolphin run without a terminal.

The installer copies the helper to `~/.local/share/dotfiles/add-to-menu.py` and
the context action to `~/.local/share/kio/servicemenus/add-to-menu.desktop`.
Rerun the install command after updating the helper. To uninstall the action,
delete those two files; application launchers already created remain available.
