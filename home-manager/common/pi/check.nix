{runCommand, nodejs_24, bash, coreutils}:
runCommand "check-pi-tools" {
  nativeBuildInputs = [nodejs_24 bash coreutils];
} ''
  mkdir -p node_modules/@earendil-works/pi-coding-agent
  cat > node_modules/@earendil-works/pi-coding-agent/package.json <<'EOF'
{"type":"module"}
EOF
  cat > node_modules/@earendil-works/pi-coding-agent/index.js <<'EOF'
export function getAgentDir() {
  return process.env.TEST_AGENT_DIR;
}

export function isToolCallEventType(tool, event) {
  return event.toolName === tool;
}
EOF

  cp ${./extensions/yolo/yolo.ts} yolo.ts
  cp ${./extensions/rtk/rtk.ts} rtk.ts
  cp ${./scripts/pi-package-update} pi-package-update
  cp ${./scripts/pi-package-security-check} pi-package-security-check
  chmod +x pi-package-update pi-package-security-check
  cp ${./pi.test.ts} pi.test.ts
  cat > package.json <<'EOF'
{"type":"module"}
EOF
  node --test pi.test.ts
  touch $out
''
