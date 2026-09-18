# DNF Updater

DNF Updater monitors and manages pending system updates for Fedora RPM packages (via DNF5) and Flatpak applications directly from the Noctalia Shell.

It provides a lightweight update badge in the bar, per-package selection to skip or apply specific upgrades, storage and download size estimation, and safe execution through Polkit (`pkexec`) or an interactive terminal.

## Plugin

| Field | Value |
| --- | --- |
| ID | `strob3/dnf-updater` |
| Entries | Bar widget: `widget`; panel: `panel`; service: `service` |

## Requirements

The plugin expects the following dependencies on `$PATH`:

- `dnf5` (Fedora RPM package manager)
- `flatpak` (Flatpak application manager)
- `pkexec` (Polkit authentication for non-interactive privileged package installation)

## Usage

Add the DNF Updater widget to your bar using Noctalia's bar widget picker. Left-click the widget to open the updates panel. You can also toggle the panel or bind it to a compositor shortcut:

```sh
noctalia msg panel-toggle strob3/dnf-updater:panel
```

### Controls

| Action | Target | Description |
| --- | --- | --- |
| **Left Click** | Bar Widget | Open or close the updates panel |
| **Right Click** | Bar Widget | Trigger an immediate update check |
| **Middle Click** | Bar Widget | Open plugin settings in *Settings → Plugins* |
| **Click Row** | Package Row | Toggle package selection (include or exclude from update) |
| **Chevron Click** | Section Header | Collapse or expand DNF or Flatpak package section |
| **Check Click** | Section Header | Select all or deselect all packages in section |
| **Update Button** | Panel Bottom | Apply updates for all selected packages |
| **Check Now** | Panel Bottom | Re-check repositories for latest updates |

## Settings

| Setting | Type | Default | Description |
| --- | --- | --- | --- |
| `check_interval` | `int` | `30` | Interval in minutes between automatic checks (`0` disables scheduled checks). |
| `enable_dnf` | `bool` | `true` | Enable checking and upgrading DNF5 system packages. |
| `enable_flatpak` | `bool` | `true` | Enable checking and upgrading Flatpak applications. |
| `show_widget_when_clean` | `bool` | `true` | Show the widget icon in the bar even when system is up to date. |
| `notify_on_updates` | `bool` | `true` | Send a desktop notification when new pending updates are found. |
| `update_in_terminal` | `bool` | `false` | Launch update commands inside your terminal emulator instead of background Polkit execution. |
| `glyph` | `glyph` | `package` | Widget icon glyph displayed in the bar. |

## IPC

Trigger background service operations using `noctalia msg`:

```sh
# Check for updates immediately
noctalia msg plugin strob3/dnf-updater:service service check

# Apply updates for all pending packages
noctalia msg plugin strob3/dnf-updater:service service update
```

## Notes

- **Privilege Separation**: Noctalia never runs as root. System upgrades invoke `pkexec dnf5 upgrade` with explicit arguments, or launch inside the user's terminal emulator when configured.
- **Selective Upgrades**: When packages are deselected, DNF5 is invoked with `--exclude=<pkg>` arguments and Flatpak is invoked with only selected application IDs.
- **Background Checks**: Update queries use non-blocking JSON queries (`dnf5 check-upgrade --json` and `flatpak remote-ls --updates -j`) to prevent freezing the shell.
