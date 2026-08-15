# Configured Application Flake Outputs

## Goal

Expose a small set of repository-configured applications through the flake so they can be launched without installing the full Home Manager configuration.

Target commands:

```bash
nix run github:valdo766hi/nix-config#neovim
nix run github:valdo766hi/nix-config#yazi
nix run github:valdo766hi/nix-config#lazygit
nix run github:valdo766hi/nix-config#pi
```

Use `valdo766hi`; `valdo76hi` is not the repository owner used elsewhere in this config.

## Scope

### 1. Neovim

- Reuse each platform's configured NVF derivation from `programs.nvf.finalPackage`.
- Export it as `packages.<system>.neovim`.
- Ensure the exported package has `meta.mainProgram = "nvim"` or provide an equivalent wrapper.
- Preserve the repository's plugins, keybindings, LSP configuration, and theme.

Expected limitation: the closure will be relatively large because NVF includes language servers and supporting tools.

### 2. Yazi

- Reuse `programs.yazi.package`, including the existing `_7zz-rar` override.
- Generate an immutable configuration directory containing `yazi.toml` and `theme.toml`.
- Wrap Yazi with `YAZI_CONFIG_HOME` pointing to that directory.
- Export the wrapper as `packages.<system>.yazi` with `meta.mainProgram = "yazi"`.

Expected limitation: launching through `nix run` cannot reproduce the `y` shell wrapper's ability to change the parent shell's directory.

### 3. LazyGit

- Package `pkgs.lazygit`; the current module writes configuration but does not install the application.
- Embed the existing Catppuccin LazyGit configuration.
- Replace the bare `delta` pager command with an absolute Nix store path or include Delta in the wrapper PATH.
- Launch LazyGit with its explicit configuration-file mechanism.
- Export the wrapper as `packages.<system>.lazygit` with `meta.mainProgram = "lazygit"`.

Git credentials, identity, and repository state must continue to come from the caller's environment.

### 4. Pi

- Reuse the configured Home Manager `programs.pi-coding-agent.package`.
- Export it as `packages.<system>.pi`.
- Preserve the existing Pi extensions, settings, and mutable `~/.pi` state.

## Flake Design

- Support `x86_64-linux` and `aarch64-darwin`.
- Prefer configured wrapper packages with `meta.mainProgram` over duplicate `apps` outputs.
- Keep application builders small and reusable instead of embedding wrapper logic directly in `flake.nix`.
- Do not export every installed nixpkgs package; users can already run those through `nix run nixpkgs#<package>`.
- Keep the existing `rtk` and default package outputs unchanged.

## Checks

Add native package checks where the current CI runner can build them:

- Linux CI builds Neovim, Yazi, LazyGit, and Pi configured outputs.
- Both Linux and Darwin outputs must evaluate with `nix flake check --all-systems --no-build`.
- Darwin builds remain evaluation-only unless a native Darwin CI runner is introduced.

Run locally:

```bash
nix flake check --all-systems --no-build --accept-flake-config
nix run .#neovim -- --version
nix run .#yazi -- --version
nix run .#lazygit -- --version
nix run .#pi -- --version
```

Also manually verify:

- Neovim loads the NVF configuration and plugins.
- Yazi loads the configured sorting, preview, and theme settings.
- LazyGit loads the configured theme and Delta pager inside a Git repository.
- Pi launches the configured Nix package; Home Manager activation supplies its extensions and settings.

## Documentation

Update `README.md` with the three commands and their limitations. Update `AGENTS.md`, then synchronize `CLAUDE.md` only with:

```bash
cp AGENTS.md CLAUDE.md
```

## Non-goals

Do not export Nushell, Atuin, OpenCode, Claude Code, Codex, Git, Kitty, or Ghostty in this iteration. Their useful behavior depends more heavily on secrets, mutable user state, shell integration, or a graphical host environment.
