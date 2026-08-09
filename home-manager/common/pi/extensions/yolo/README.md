# Pi YOLO extension

This extension registers `/yolo` and keeps the session's YOLO state in sync with
`@gotgenes/pi-permission-system`'s native `yoloMode` setting.

## Commands

```text
/yolo       # toggle
/yolo on    # enable
/yolo off   # disable
```

The state is stored in the Pi session as `yolo-state`. A fresh session starts
off; resuming or reloading a session reapplies its stored state.

## Permission behavior

Native YOLO changes only `ask` decisions to `allow`. Explicit `deny` rules are
never changed. This means YOLO can read external directories while still
blocking rules such as secret-file and destructive-command denials.

The native permission-system config is declared in the sibling
`../pi-permission-system/config.json`. The command updates the live config
atomically at:

```text
~/.pi/agent/extensions/pi-permission-system/config.json
```

(`PI_CODING_AGENT_DIR` is honored by Pi.) Home Manager may restore the
Nix-declared file during a later activation, so restart Pi after activation and
toggle YOLO again if needed.

See [`docs/PI_YOLO.md`](../../../../../docs/PI_YOLO.md) for the user-facing
behavior, protected rules, and troubleshooting notes.
