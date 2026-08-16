# Pi package maintenance

These scripts make Pi package updates audit-first and keep the Home Manager
module as the source of truth.

> Here, **secure** means that npm reports no known advisories. An audit cannot
> prove that package code is safe or non-malicious.

## Installed security check

```sh
pi-package-security-check
```

Audits the complete installed dependency tree, including development
dependencies, in `~/.pi/agent/npm`.

To repair vulnerable transitive dependencies without allowing breaking
upgrades, run:

```sh
pi-package-security-check --repair
```

This applies the repository's safe npm overrides, runs `npm audit fix` with
install scripts and `--force` disabled, then audits the repaired tree.

Exit codes distinguish the outcomes:

- `0`: no known vulnerabilities
- `1`: known vulnerabilities found
- `2`: audit could not run or its result was invalid

## Candidate security check

```sh
pi-package-security-check --candidate pi-lens@3.8.71
pi-package-security-check --candidate \
  pi-lens@3.8.71 \
  @plannotator/pi-extension@0.24.2
```

Candidate versions must be exact semantic versions. The script copies the
current manifest and lockfile to a temporary directory, applies the safe
`fast-uri` override, simulates all supplied updates with install scripts
disabled, repairs semver-compatible transitive dependencies, and audits the
resulting combined tree. It does not change the live installation.

## Find secure updates

```sh
pi-package-update check
pi-package-update check pi-lens pi-subagents
```

The updater considers only registry versions semantically newer than exact
pins in `home-manager/common/pi/default.nix`. It audits each candidate and then
audits all accepted candidates together.

## Update secure pins

```sh
pi-package-update update
pi-package-update update pi-lens
```

The updater writes only candidates that pass both audits. All accepted pins
are written atomically; registry, checker, combined-audit, or editing errors
leave the configuration unchanged. A vulnerable candidate is skipped, while
other secure candidates may still be updated together.

The command finds this repository automatically at `$XDG_CONFIG_HOME/nix`
(default `~/.config/nix`) or from the current Git checkout. Direct package
versions are pinned in the Nix module, but the installed dependency tree under
`~/.pi/agent/npm` remains mutable application state and is not represented in
`flake.lock`; run the security check after activation. For a different
checkout, set:

```sh
PI_PACKAGES_CONFIG=/path/to/home-manager/common/pi/default.nix \
  pi-package-update check
```

The scripts deliberately do not activate Home Manager. `update` only changes
the Nix source and candidate checks use isolated temporary trees. After normal
activation, repair and verify the installed result:

```sh
pi-package-security-check --repair
pi-package-security-check
```

The repair is limited to safe npm fixes and the pinned `fast-uri` override;
it never uses `npm audit fix --force`.

Pi is launched with an allowlisted environment: only the Context7 and Exa
credentials needed by its configured MCP servers are passed through from the
interactive shell. The permission rules are approval UX, not a process
sandbox; keep the Bash default at `ask` and treat `/yolo` as an explicit
opt-out.

Both scripts print stable `[INFO]`, `[PASS]`, `[SKIP]`, `[FAIL]`, `[AUDIT]`,
and `[VULNERABLE]` messages plus meaningful exit codes so people and AI agents
can use the same workflow.

## Skill security checks

Pi auto-allows read-only tools for global skills under `~/.agents/skills`, its
built-in `~/.pi/agent` infrastructure, and Pi-created `pi-clipboard-*` files in
the operating system's temporary directory. Writes, edits, and helper-script
execution outside the working directory still require the normal external-path
approval. Existing path denials for secrets such as `.env`, SSH keys, and cloud
credentials still take precedence.

Scan one skill or a directory containing multiple skills:

```sh
skill-sec-check.sh ~/.agents/skills
skill-sec-check.sh ~/.agents/skills/ponytail
skill-sec-check.sh ~/.agents/skills/ponytail/SKILL.md
```

The command finds skills by `SKILL.md` and recursively runs Trivy's
vulnerability, secret, and misconfiguration scanners. Exit codes distinguish
the outcomes:

- `0`: no findings
- `1`: findings require review
- `2`: invalid input or the scan could not complete

A clean scan only means that these automated scanners found nothing. Skills
contain instructions and executable code, so review their source before use.
