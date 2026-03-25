# Unified NixOS + nix-darwin Guidelines

This repository manages one NixOS host and two macOS hosts with a shared Home Manager base.

## Quick Commands

```bash
# Always do this first
nix flake check

# NixOS (local on thinker)
sudo nixos-rebuild switch --flake .#thinker

# macOS (run on the target Mac)
sudo darwin-rebuild switch --flake .#Rivaldos-MacBook-Pro

# macOS (MacBook Air)
sudo darwin-rebuild switch --flake .#Rivaldos-MacBook-Air

# Update all inputs
nix flake update
```

## Repository Layout

- `flake.nix`: main entrypoint, host outputs, shared module wiring
- `flake.lock`: pinned inputs
- `hosts/`
  - `hosts/nixos/thinker/configuration.nix`: thin NixOS host wrapper
  - `hosts/nixos/thinker/hardware-configuration.nix`: hardware-specific file
  - `hosts/darwin/configuration.nix`: thin Darwin host wrapper
- `modules/`
  - `modules/nixos/common/default.nix`: shared NixOS system settings
  - `modules/nixos/desktop.nix`, `modules/nixos/virtualisation.nix`, `modules/nixos/secrets.nix`
  - `modules/darwin/common/default.nix`, `modules/darwin/homebrew/default.nix`, `modules/darwin/aerospace/default.nix`, `modules/darwin/secrets.nix`
- `home-manager/`
  - `home-manager/home.nix`: shared HM base (single canonical home file)
  - `home-manager/common/`: shared HM modules
  - `home-manager/nixos/`: Linux-only HM modules
  - `home-manager/darwin/`: macOS-only HM modules
- `secrets/`
  - `secrets/secrets.yaml`: encrypted with sops
  - `.sops.yaml`: sops creation rules
- `docs/`
  - `docs/AEROSPACE_KEYBINDINGS.md`
  - `docs/NIRI_KEYBINDINGS.md`
  - `docs/NVF_KEYBINDINGS.md`
  - `docs/RTK_OPENCODE.md`

## Current Design Rules

1. Host files stay thin; real config goes in reusable modules.
2. Home Manager has one shared base (`home-manager/home.nix`), platform specifics are imported by host wiring.
3. One package manager owner per tool:
   - Nix system modules or Home Manager for CLI tools
   - Homebrew for macOS GUI apps; keep CLI tools in Nix and avoid duplicate ownership across layers
4. Secrets are managed via `sops-nix`, not plain text files.

## Package Ownership Policy

- CLI tools: managed by Nix, either in system modules or Home Manager
- Tools with native NixOS or nix-darwin options should live in `modules/*`
- GUI apps on macOS: managed by Homebrew casks (`modules/darwin/homebrew/default.nix`)
- Homebrew formulas on macOS: avoid for CLI tools unless strictly necessary
- Avoid duplicates across system modules, Home Manager, and Homebrew.

## Secrets (sops-nix)

- Encrypted source: `secrets/secrets.yaml`
- NixOS key file: `/home/rivaldo/.config/sops/age/keys.txt`
- Darwin key file: `/Users/rivaldo/.config/sops/age/keys.txt`
- Managed secret keys currently include:
  - `fish_secrets`
  - `nushell_secrets`
  - `winapps_rdp_user`
  - `winapps_rdp_pass`

Edit secrets with:

```bash
nix shell nixpkgs#sops -c sops secrets/secrets.yaml
```

## Pre-Change Checklist

1. `nix flake check`
2. `git status --short`
3. For bootloader-related NixOS changes: `df -h /boot`

## Common Workflows

### Add a shared CLI package

If it is user-scoped and does not need system integration, edit `home-manager/common/packages.nix`.

If it needs native system options or shell/system integration, add it in `modules/nixos/common/default.nix` and/or `modules/darwin/common/default.nix`.

### Add Linux-only Home Manager config

1. Create file in `home-manager/nixos/`
2. Import it from `home-manager/nixos/default.nix`

### Add macOS-only Home Manager config

1. Create file in `home-manager/darwin/`
2. Import it from `home-manager/darwin/default.nix`

### Add NixOS system module

1. Create file in `modules/nixos/`
2. Export/import through `flake.nix` and host wrapper

### Add Darwin system module

1. Create file in `modules/darwin/`
2. Export/import through `flake.nix` and `hosts/darwin/configuration.nix`

## Validation

```bash
# Global
nix flake check

# NixOS
sudo nixos-rebuild dry-build --flake .#thinker
home-manager build --flake .#rivaldo@thinker

# Darwin local (on the target Mac)
darwin-rebuild build --flake .#Rivaldos-MacBook-Pro

# Darwin local (MacBook Air)
darwin-rebuild build --flake .#Rivaldos-MacBook-Air
```

## Known Operational Notes

- Flake mode only sees tracked files. If you add/rename files and see "path ... does not exist", run `git add -A` first.
- Home Manager collision handling is enabled with `backupFileExtension = "hm-bak"`.
- If HM fails with `Permission denied` in `~/.config/*`, fix ownership once:
  - `sudo chown -R rivaldo:staff ~/.config/nushell ~/.config/fish`

## Rollback

### NixOS

```bash
sudo nixos-rebuild switch --rollback --flake .#thinker
```

### Darwin

```bash
darwin-rebuild switch --rollback --flake .#Rivaldos-MacBook-Pro

# Or on the MacBook Air
darwin-rebuild switch --rollback --flake .#Rivaldos-MacBook-Air
```

## Commit Style

- Imperative present tense (`Add`, `Fix`, `Refactor`, `Update`)
- Keep scope clear
- Examples:
  - `Refactor Darwin host wiring and Home Manager composition`
  - `Add sops-nix secrets module for macOS`
  - `Fix Home Manager homeDirectory resolution on Darwin`
