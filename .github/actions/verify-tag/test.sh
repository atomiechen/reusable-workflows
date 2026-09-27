#!/usr/bin/env bash
set -euo pipefail

resolver=$(cd "$(dirname "$0")" && pwd)/resolve-tag.sh
fixture=$(mktemp -d)
trap 'rm -rf "$fixture"' EXIT
cd "$fixture"
git init -q
git config user.email test@example.invalid
git config user.name Test

commit_at() {
  local date=$1
  local message=$2
  GIT_AUTHOR_DATE="$date" GIT_COMMITTER_DATE="$date" git commit -qm "$message"
}

printf 'first\n' > file
git add file
commit_at '2024-01-01T00:00:00Z' first
git tag v1.0.0

printf 'second\n' > file
git add file
commit_at '2024-01-02T00:00:00Z' second
git tag codegen-v2.0.0

printf 'third\n' > file
git add file
commit_at '2024-01-03T00:00:00Z' third
git tag v1.1.0

expect_tag() {
  local expected=$1
  shift
  local actual
  actual=$(bash "$resolver" "$@")
  [[ "$actual" == "tag=$expected" ]] || {
    echo "Expected $expected, got $actual" >&2
    exit 1
  }
}

expect_fail() {
  if bash "$resolver" "$@" >/dev/null 2>&1; then
    echo "Unexpectedly accepted tag selection: $*" >&2
    exit 1
  fi
}

expect_tag v1.1.0 '' ''
expect_tag v1.1.0 '' 'v*'
expect_tag codegen-v2.0.0 '' 'codegen-v*'
expect_tag v1.0.0 'v1.0.0' 'v*'
expect_fail 'codegen-v2.0.0' 'v*'
expect_fail 'v9.0.0' 'v*'
expect_fail '' 'missing-*'

echo 'verify-tag tests passed'
