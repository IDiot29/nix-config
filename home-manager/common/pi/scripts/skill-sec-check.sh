#!/usr/bin/env bash
set -euo pipefail

REPORT=""
SKILL_LIST=""

cleanup() {
	[[ -z "$REPORT" ]] || rm -f "$REPORT"
	[[ -z "$SKILL_LIST" ]] || rm -f "$SKILL_LIST"
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
-h | --help)
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
	TARGET_INPUT="$(dirname "$1")"
else
	TARGET_INPUT="$1"
fi

if ! TARGET="$(cd "$TARGET_INPUT" && pwd -P)"; then
	fail "Could not resolve skill path: $1"
	exit 2
fi

if ! SKILL_LIST="$(mktemp "${TMPDIR:-/tmp}/skill-sec-list.XXXXXX")"; then
	fail "Could not create the temporary skill list"
	exit 2
fi
if ! find "$TARGET" -type f -name SKILL.md ! -path '*/.git/*' -print0 >"$SKILL_LIST"; then
	fail "Could not enumerate skills under $TARGET"
	exit 2
fi

SKILL_COUNT=0
while IFS= read -r -d '' _skill; do
	((SKILL_COUNT += 1))
done <"$SKILL_LIST"
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

if ! REPORT="$(mktemp "${TMPDIR:-/tmp}/skill-sec-check.XXXXXX")"; then
	fail "Could not create the temporary Trivy report"
	exit 2
fi
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

if ! COUNTS="$(jq -er '
  if (.SchemaVersion | type) != "number" or
     (.ArtifactName | type) != "string" or
     ((.Results == null) | not) and ((.Results | type) != "array")
  then error("unexpected Trivy report structure")
  else [
    ([.Results[]?.Vulnerabilities[]?] | length),
    ([.Results[]?.Secrets[]?] | length),
    ([.Results[]?.Misconfigurations[]?] | length)
  ] | @tsv
  end
' "$REPORT")"; then
	fail "Trivy returned an invalid or unsupported JSON report"
	exit 2
fi

IFS=$'\t' read -r VULNERABILITIES SECRETS MISCONFIGURATIONS <<<"$COUNTS"
if [[ ! "$VULNERABILITIES" =~ ^[0-9]+$ ||
	! "$SECRETS" =~ ^[0-9]+$ ||
	! "$MISCONFIGURATIONS" =~ ^[0-9]+$ ]]; then
	fail "Trivy report counts were not numeric"
	exit 2
fi
TOTAL=$((VULNERABILITIES + SECRETS + MISCONFIGURATIONS))

printf '[SCAN] vulnerabilities=%s secrets=%s misconfigurations=%s total=%s\n' \
	"$VULNERABILITIES" "$SECRETS" "$MISCONFIGURATIONS" "$TOTAL"

if ! jq -r '
  def finding($kind; $details): "[\($kind)] \($details | tojson)";
  .Results[]? as $result |
    ($result.Vulnerabilities[]? |
      finding("VULNERABLE"; {
        package: (.PkgName // "unknown"),
        id: (.VulnerabilityID // "unknown"),
        severity: (.Severity // "UNKNOWN"),
        target: ($result.Target // "unknown")
      })),
    ($result.Secrets[]? |
      finding("SECRET"; {
        rule: (.RuleID // "unknown"),
        severity: (.Severity // "UNKNOWN"),
        target: ($result.Target // "unknown")
      })),
    ($result.Misconfigurations[]? |
      finding("MISCONFIG"; {
        id: (.ID // "unknown"),
        severity: (.Severity // "UNKNOWN"),
        target: ($result.Target // "unknown")
      }))
' "$REPORT" >&2; then
	fail "Could not render the Trivy findings"
	exit 2
fi

if [[ "$TOTAL" -gt 0 ]]; then
	fail "Skill scan found items that require review"
	exit 1
fi

printf '[PASS] No known vulnerabilities, exposed secrets, or misconfigurations found.\n'
