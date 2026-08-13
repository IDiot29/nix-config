# Runs the fast-mode extension's tests under Node's built-in test runner.
# Exposed as the `pi-fast-extension` flake check.
{
  runCommand,
  nodejs_24,
}:
runCommand "check-pi-fast-extension" {
  nativeBuildInputs = [nodejs_24];
} ''
  cp ${./fast.ts} fast.ts
  cp ${./fast.test.ts} fast.test.ts
  node --test fast.test.ts
  touch $out
''
