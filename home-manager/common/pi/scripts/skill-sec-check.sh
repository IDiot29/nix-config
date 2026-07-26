#!/usr/bin/env bash
set -euo pipefail

REPORT=""

cleanup() {
  [[ -z "$REPORT" ]] || rm -f "$REPORT"
}
trap cleanup EXIT

fail() { printf '[FAIL] %s\n' "$*" >&2; }

usage() {
  cat <<'EOF'
Usage: skill-sec-check.sh SKILL_PATH

Recursively scans a skill directory, a directory containing multiple skills,
or one SKILL.md file with Trivy's vulnerability, secret, and misconfiguration
scanners.

Exit codes:
  0  No findings
  1  Findings require review
  2  Invalid input or scan failure
EOF
}

case "${1:-}" in
  -h|--help)
    usage
    exit 0
    ;;
esac

if [[ $# -ne 1 ]]; then
  usage >&2
  exit 2
fi

if [[ ! -e "$1" ]]; then
  fail "Path does not exist: $1"
  exit 2
fi

if [[ -f "$1" ]]; then
  if [[ "${1##*/}" != "SKILL.md" ]]; then
    fail "Expected a skill directory or SKILL.md: $1"
    exit 2
  fi
  TARGET="$(cd "$(dirname "$1")" && pwd -P)"
else
  TARGET="$(cd "$1" && pwd -P)"
fi

SKILL_COUNT="$(find "$TARGET" -type f -name SKILL.md -not -path '*/.git/*' | wc -l | tr -d ' ')"
if [[ "$SKILL_COUNT" -eq 0 ]]; then
  fail "No SKILL.md files found under $TARGET"
  exit 2
fi

if ! command -v trivy >/dev/null 2>&1; then
  fail "trivy is required but is not installed"
  exit 2
fi
if ! command -v jq >/dev/null 2>&1; then
  fail "jq is required but is not installed"
  exit 2
fi

REPORT="$(mktemp "${TMPDIR:-/tmp}/skill-sec-check.XXXXXX")"
printf '[INFO] Scanning %s skill(s) under %s\n' "$SKILL_COUNT" "$TARGET"

if ! trivy fs \
  --scanners vuln,secret,misconfig \
  --skip-dirs .git \
  --format json \
  --output "$REPORT" \
  "$TARGET"; then
  fail "Trivy could not complete the scan"
  exit 2
fi

VULNERABILITIES="$(jq '[.Results[]?.Vulnerabilities[]?] | length' "$REPORT")"
SECRETS="$(jq '[.Results[]?.Secrets[]?] | length' "$REPORT")"
MISCONFIGURATIONS="$(jq '[.Results[]?.Misconfigurations[]?] | length' "$REPORT")"
TOTAL=$((VULNERABILITIES + SECRETS + MISCONFIGURATIONS))

printf '[SCAN] vulnerabilities=%s secrets=%s misconfigurations=%s total=%s\n' \
  "$VULNERABILITIES" "$SECRETS" "$MISCONFIGURATIONS" "$TOTAL"

jq -r '.Results[]? as $result | $result.Vulnerabilities[]? |
  "[VULNERABLE] \(.PkgName // "unknown") \(.VulnerabilityID // "unknown") severity=\(.Severity // "UNKNOWN") target=\($result.Target // "unknown")"' \
  "$REPORT" >&2
jq -r '.Results[]? as $result | $result.Secrets[]? |
  "[SECRET] \(.RuleID // "unknown") severity=\(.Severity // "UNKNOWN") target=\($result.Target // "unknown")"' \
  "$REPORT" >&2
jq -r '.Results[]? as $result | $result.Misconfigurations[]? |
  "[MISCONFIG] \(.ID // "unknown") severity=\(.Severity // "UNKNOWN") target=\($result.Target // "unknown")"' \
  "$REPORT" >&2

if [[ "$TOTAL" -gt 0 ]]; then
  fail "Skill scan found items that require review"
  exit 1
fi

printf '[PASS] No known vulnerabilities, exposed secrets, or misconfigurations found.\n'
