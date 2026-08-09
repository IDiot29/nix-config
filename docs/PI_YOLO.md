# Pi YOLO mode

This repository's `/yolo` command provides fast approval for permission checks
without disabling the permission policy's explicit denials.

## Usage

```text
/yolo       # toggle the current session
/yolo on    # enable
/yolo off   # disable
```

After changing the mode, the next agent turn uses the updated permission
setting. Restart Pi after a Home Manager activation.

## What YOLO changes

YOLO uses the native `@gotgenes/pi-permission-system` `yoloMode` behavior:

| Policy result | YOLO off | YOLO on |
| --- | --- | --- |
| `allow` | allowed | allowed |
| `ask` | prompts or follows the configured authorizer | allowed |
| `deny` | blocked | blocked |

Therefore, an external path that normally hits the configured
`external_directory: "ask"` boundary can be read or written while YOLO is on.
The separate `path` and `bash` rules still apply, so an explicit denial cannot
be bypassed by YOLO.

YOLO is not a general unrestricted mode. In particular, it does not turn a
`deny` rule into an `allow` rule. It does auto-approve rules configured as
`ask`, such as `sudo *` or `git clean *` in this repository; change those rules
to `deny` if they must remain blocked even in YOLO mode.

## Protected rules in this configuration

The permission policy continues to deny, among other things:

- secret files such as `.env`, SSH, GnuPG, AWS, Kubernetes, Docker, npm, and
  Pi authentication files;
- destructive commands such as `rm *`, `shred *`, filesystem formatting and
  partitioning commands, recursive ownership/permission changes, shutdown and
  reboot commands;
- forced Git pushes and hard resets.

The source policy is
`home-manager/common/pi/extensions/pi-permission-system/config.json`.

## How it is wired

- `home-manager/common/pi/extensions/yolo/yolo.ts` registers the command and
  stores `yolo-state` in the current Pi session.
- `home-manager/common/pi/extensions/pi-permission-system/config.json` keeps
  native `yoloMode` disabled by default.
- `/yolo` updates the live permission-system config atomically at
  `~/.pi/agent/extensions/pi-permission-system/config.json`.
- Home Manager installs both files through
  `home-manager/common/pi/default.nix`.

Because Home Manager manages the live config path, a later activation can
restore the declared default (`yoloMode: false`). That is intentional: the
repository remains safe by default, and the session command can enable YOLO
again when needed.

## Troubleshooting

1. Run `/yolo on` and start the next agent turn.
2. Check the footer for `YOLO: ON`.
3. If an external path still prompts, restart Pi after Home Manager activation
   and try again.
4. Use `/permission-system show` to inspect the active native setting after the
   next agent turn.

If a protected path or command is still blocked in YOLO mode, that is expected
when a `deny` rule matched it. Do not weaken the deny rule merely to make YOLO
work; check whether the path or command is intentionally protected.
