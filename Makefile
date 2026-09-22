PREFIX ?= /usr/local
POLKIT_DIR ?= /etc/polkit-1/rules.d

.PHONY: all install uninstall help

all: help

help:
	@echo "DNF Updater - Build & Installation Targets"
	@echo ""
	@echo "Usage:"
	@echo "  sudo make install    - Install privileged helper and Polkit rule"
	@echo "  sudo make uninstall  - Remove installed helper and Polkit rule"
	@echo ""
	@echo "Variables:"
	@echo "  DESTDIR      Optional staging root directory (e.g. for packaging)"
	@echo "  PREFIX       Installation prefix (default: /usr/local)"
	@echo "  POLKIT_DIR   Polkit rules directory (default: /etc/polkit-1/rules.d)"

install:
	install -Dm755 scripts/dnf-updater-helper.sh $(DESTDIR)$(PREFIX)/bin/dnf-updater-helper
	install -Dm644 polkit/50-dnf-updater.rules $(DESTDIR)$(POLKIT_DIR)/50-dnf-updater.rules
	@echo "Installed helper to $(DESTDIR)$(PREFIX)/bin/dnf-updater-helper"
	@echo "Installed Polkit rule to $(DESTDIR)$(POLKIT_DIR)/50-dnf-updater.rules"

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/dnf-updater-helper
	rm -f $(DESTDIR)$(POLKIT_DIR)/50-dnf-updater.rules
	@echo "Removed helper and Polkit rule."
