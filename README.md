# Unified NixOS + nix-darwin Config

This repository manages my Linux and macOS machines from one flake.

The design is simple:

- keep host files thin
- keep reusable logic in modules
- keep Home Manager shared-first
- keep secrets encrypted with `sops-nix`

## Hosts

- NixOS: `thinker`
- Darwin: `Rivaldos-MacBook-Pro`

## Directory guide

- `flake.nix` - inputs, host outputs, shared Home Manager module lists, and evaluation checks
- `caches.nix` - shared host cache URLs and trusted keys
- `.github/workflows/check.yml` - deterministic flake validation in CI
- `hosts/` - minimal host wrappers
- `modules/` - reusable system modules
  - `modules/nixos/` for NixOS-only system config
  - `modules/darwin/` for macOS-only system config
- `home-manager/` - user config
  - `home-manager/home.nix` shared base
  - `home-manager/common/` cross-platform HM modules
  - `home-manager/nixos/` Linux-only HM modules
  - `home-manager/darwin/` macOS-only HM modules
- `secrets/` - encrypted secrets data
- `docs/` - keybind, editor, and Pi behavior docs
  - `docs/PI_YOLO.md` - Pi YOLO behavior and troubleshooting
- `home-manager/common/pi/extensions/yolo/` - Pi `/yolo` extension and its README

## Daily commands

Run these from the repo root.

```bash
# Evaluate every supported system without building
nix flake check --all-systems --no-build

# Apply NixOS
sudo nixos-rebuild switch --flake .#thinker

# Apply Darwin (run on the target Mac)
sudo darwin-rebuild switch --flake .#Rivaldos-MacBook-Pro
```

## Package ownership policy

Use one owner per tool to avoid path conflicts:

- CLI tools -> Nix (system modules or Home Manager)
- Tools with native OS integration -> prefer system modules
- macOS GUI apps -> Homebrew casks
- Homebrew formulas -> avoid for CLI tools unless strictly necessary

If a tool is already managed in Nix, do not also manage it in Brew.

The repository-owned `rtk` package is exported for both hosts and can be run without installation:

```bash
nix run github:valdo766hi/nix-config#rtk
```

Other installed tools come from nixpkgs and can be run directly with `nix run nixpkgs#<package>` when they provide an executable.

Niri is intentionally split by responsibility: its NixOS module owns installation, system integration, and the display-manager session; Home Manager owns the user configuration file.

## Secrets

Secrets are managed with `sops-nix`.

- Encrypted file: `secrets/secrets.yaml`
- Private SSH host configuration is rendered from the encrypted `ssh_config` value.
- Linux key: `/home/rivaldo/.config/sops/age/keys.txt`
- macOS key: `/Users/rivaldo/.config/sops/age/keys.txt`

Edit secrets:

```bash
nix shell nixpkgs#sops -c sops secrets/secrets.yaml
```

## How to modify this repo safely

1. Run `nix flake check --all-systems --no-build` before changing anything.
2. Make the change in the right layer:
   - system-level -> `modules/*`
   - user-level -> `home-manager/*`
   - shared user-scoped CLI tools -> `home-manager/common/packages.nix`
3. Import new module from the nearest `default.nix` aggregator.
4. `git add -A` when adding/renaming files (flakes only see tracked files).
5. Run `nix flake check --all-systems --no-build` again.
6. Apply on target host.

## Automated checks

GitHub Actions runs `nix flake check --all-systems` for every push and pull request. The workflow uses commit-pinned actions, evaluates both host configurations, and builds the Linux `rtk` package.

## Validation shortcuts

```bash
# NixOS dry run
sudo nixos-rebuild dry-build --flake .#thinker

# Home Manager eval on Linux
home-manager build --flake .#rivaldo@thinker

# Darwin build (on the target Mac)
darwin-rebuild build --flake .#Rivaldos-MacBook-Pro
```

## Troubleshooting notes

- If Home Manager reports file collisions, backups are saved as `*.hm-bak`.
- If HM fails with permission errors in `~/.config/*`, fix ownership:

```bash
sudo chown -R rivaldo:staff ~/.config/nushell ~/.config/fish
```

- If flake says a path does not exist in `/nix/store/...-source`, you likely forgot to stage files: `git add -A`.
- Host cache settings come from `caches.nix`. Keep the literal `flake.nix` `nixConfig` values synchronized because flake-level settings cannot import them.

## Rollback

```bash
# NixOS
sudo nixos-rebuild switch --rollback --flake .#thinker

# Darwin (on the target Mac)
darwin-rebuild switch --rollback --flake .#Rivaldos-MacBook-Pro
```
