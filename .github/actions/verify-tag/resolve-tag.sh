#!/usr/bin/env bash
set -euo pipefail

requested_tag=${1-}
tag_pattern=${2-}

if [[ -n "$requested_tag" ]]; then
  if [[ -n "$tag_pattern" && "$requested_tag" != $tag_pattern ]]; then
    echo "Tag '$requested_tag' does not match '$tag_pattern'." >&2
    exit 1
  fi
  if ! git rev-parse -q --verify "refs/tags/$requested_tag" >/dev/null; then
    echo "Tag '$requested_tag' does not exist." >&2
    exit 1
  fi
  selected_tag=$requested_tag
elif [[ -n "$tag_pattern" ]]; then
  latest_commit=$(git rev-list --tags="$tag_pattern" --max-count=1)
  if [[ -z "$latest_commit" ]]; then
    echo "No tag matches '$tag_pattern'." >&2
    exit 1
  fi
  selected_tag=$(git describe --tags --match="$tag_pattern" "$latest_commit")
else
  # Preserve the historical unfiltered selection for existing callers.
  latest_commit=$(git rev-list --tags --max-count=1)
  if [[ -z "$latest_commit" ]]; then
    echo "No tags exist." >&2
    exit 1
  fi
  selected_tag=$(git describe --tags "$latest_commit")
fi

echo "Selected tag: $selected_tag" >&2
echo "tag=$selected_tag"
