#!/usr/bin/env bash
set -euo pipefail

workflow=$(cd "$(dirname "$0")/../workflows" && pwd)/publish-npm-package.yml
publish_command='run: npm publish ./out/*.tgz --access public --provenance'
if [[ $(grep -Fxc "$publish_command" < <(sed 's/^[[:space:]]*//' "$workflow")) -ne 2 ]]; then
  echo 'Both npm publish branches must use an explicit local tarball path.' >&2
  exit 1
fi

fixture=$(mktemp -d)
trap 'rm -rf "$fixture"' EXIT
mkdir -p "$fixture/out" "$fixture/package"
printf '%s\n' '{"name":"@example/npm-local-tarball-test","version":"0.0.0"}' > "$fixture/package/package.json"
printf '%s\n' 'module.exports = 1;' > "$fixture/package/index.js"

(
  cd "$fixture/package"
  npm pack --pack-destination "$fixture/out" --silent > /dev/null
)
(
  cd "$fixture"
  npm publish --dry-run --ignore-scripts --access public ./out/*.tgz > publish.log 2>&1
  grep -Fq '+ @example/npm-local-tarball-test@0.0.0' publish.log
)

echo 'npm recognized the tarball as a local package'
