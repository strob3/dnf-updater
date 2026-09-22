## [1.0.2] - 2026-09-22

### Added
- **One-Line Installer & Uninstaller**: Added `scripts/install.sh` supporting zero-navigation remote installation (`curl -fsSL ... | sudo bash`), location-agnostic local execution (`sudo ./scripts/install.sh`), automated preflight group checks (`wheel` and `sudo`), SELinux context restoration (`restorecon`), and single-command uninstallation (`--uninstall`).
- **Makefile Targets**: Added root `Makefile` with standard `install` and `uninstall` targets for build and packaging workflows.

### Fixed
- **Check Timeout Mitigation**: Added automatic single-retry logic in `service.luau` when Noctalia flags a timeout on DNF or Flatpak checks, preventing transient timeout error badges while remote metadata caches populate.
- **Exclusion Regex Modular Stream Support**: Updated `scripts/dnf-updater-helper.sh` exclusion validation regex to support colons (`:`), permitting exclusion of RPM modular streams (e.g. `nodejs:18`) and epochs.
- **Helper Shebang & Help Flag**: Updated helper shebang to `#!/bin/bash` for deterministic privileged execution, and added `-h`/`--help` usage flags.
- **Polkit Multi-Distro & Fallthrough Support**: Expanded `polkit/50-dnf-updater.rules` to authorize active local users in either `wheel` or `sudo` groups, and added standard explicit `polkit.Result.NOT_HANDLED` fallback.
- **Concurrency Guarding**: Added `isChecking` check to `update_dnf` and `update_flatpak` commands in `service.luau` to prevent DNF cache lock contention during automated checks.
- **Error Capture in Service**: Captured `stdout` on failed DNF transactions if `stderr` is empty, preserving dependency solver messages.
- **UI Tree & Localization Cleanup**: Removed unsupported `tooltip` properties from `ui.row` elements in `panel.luau` to eliminate Noctalia log warnings, and localized `"Last Checked"` in `widget.luau` via `translations/en.json`.

## [1.0.1] - 2026-09-21

### Security
- **Scoped Privileged Helper for Passwordless Upgrades**: Replaced the unrestricted `pkexec dnf5` Polkit rule with a dedicated, hardened privileged helper (`scripts/dnf-updater-helper.sh`) and scoped Polkit rule (`polkit/50-dnf-updater.rules`). The helper strictly enforces that only `upgrade` operations with validated `--exclude` arguments can be executed as root, eliminating arbitrary root execution while preserving passwordless background updates as an optional feature.
- **Dynamic Argument Validation**: Added strict identifier validation for DNF package names (`isValidPackageName`) and Flatpak application IDs / refs (`isValidFlatpakId`) to reject invalid characters and prevent flag or command injection.
- **Shell-Safe Argument Quoting**: Added `shellQuote` escaping for all dynamic arguments passed into `noctalia.runInTerminal()`.

### Fixed
- **Flatpak Update Execution in Terminal**: Chained DNF and Flatpak commands sequentially in a single terminal session (`sudo dnf5 upgrade ... && flatpak update ...`) when "Update All" runs with `update_in_terminal = true`, resolving an issue where back-to-back terminal launches caused Flatpak updates to be dropped.
- **Flatpak Update Scope & Ref Resolution**: Updated `flatpak update` invocation to run without package arguments when all pending Flatpak updates are selected (ensuring runtimes and dependencies update cleanly), and accurately target explicit refs when a subset is selected.
- **Total Estimated Update Size**: Added `parseSizeToBytes` and `getPackageDownloadBytes` to parse GLib/Flatpak formatted size strings (accounting for UTF-8 non-breaking spaces and SI/IEC units), correctly incorporating Flatpak download sizes into the total size badge, panel headers, and widget tooltips.
- **Panel Package Key Consistency**: Standardized Flatpak package keys across selection toggles, row click handlers, and exclusion filters using `getFlatpakKey`.

## [1.0.0] - 2026-09-19

### Added
- Initial release of DNF Updater.
- Monitoring for DNF5 system packages and Flatpak application updates.
- Interactive panel with per-package inclusion/exclusion.
- Download and installed size estimations.
- Terminal execution mode and background Polkit execution mode.
- Bar widget with badge counts and status indicators.
