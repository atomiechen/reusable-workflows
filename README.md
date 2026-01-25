# Resuable Workflows and Composite Actions

## Resuable Workflows

### Publish python distributions

Publish Python distributions to TestPyPI and PyPI, and create a GitHub Release.

Usage:

```yaml
uses: atomiechen/reusable-workflows/.github/workflows/publish-python-distributions.yml@main
with:
  publish_testpypi: true  # (Optional) Publish to TestPyPI. Default: false
  publish_pypi: true  # (Optional) Publish to PyPI. Default: false
  publish_gh_release: true  # (Optional) Publish to GitHub Release. Default: true
  use_changelog: true  # (Optional) Extract release notes from CHANGELOG.md. Default: true
  changelog_file: CHANGELOG.md  # (Optional) Path to changelog file. Default: CHANGELOG.md
  release_tag: v1.0.0  # (Optional) Tag to package (empty for latest tag). Default: ""
  package_dir: .  # (Optional) Directory where the Python package is located. Default: .
secrets:
  TEST_PYPI_API_TOKEN: ${{ secrets.TEST_PYPI_API_TOKEN }}  # Required if set publish_testpypi
  PYPI_API_TOKEN: ${{ secrets.PYPI_API_TOKEN }}  # Required if set publish_pypi
```

### Publish VSCode Extension

Publish VSCode extensions to VS Marketplace, Open VSX Registry, and create a GitHub Release.

Usage:

```yaml
uses: atomiechen/reusable-workflows/.github/workflows/publish-vse.yml@main
with:
  publish_marketplace: true  # (Optional) Publish to VS Marketplace. Default: false
  publish_openvsx: true  # (Optional) Publish to Open VSX Registry. Default: false
  publish_github: true  # (Optional) Publish to GitHub release. Default: false
  use_changelog: true  # (Optional) Extract release notes from CHANGELOG.md. Default: true
  changelog_file: CHANGELOG.md  # (Optional) Path to changelog file. Default: CHANGELOG.md
  release_tag: v1.0.0  # (Optional) Tag to release (empty for latest tag). Default: ""
secrets:
  VSCE_PAT: ${{ secrets.VSCE_PAT }}  # Required if set publish_marketplace
  OVSX_PAT: ${{ secrets.OVSX_PAT }}  # Required if set publish_openvsx
```

## Composite Actions

### Verify Tag

Verify the input tag or fetch the latest tag, and checkout to that tag if requested.

Usage:

```yaml
- name: Verify and checkout to specified tag
  id: verify_tag
  uses: atomiechen/reusable-workflows/.github/actions/verify-tag@main
  with:
    tag: v1.0.0  # (Optional) Tag to verify (empty for fetching latest tag). Default: ""
    checkout: true  # (Optional) Whether to checkout to the verified or fetched tag. Default: false

# Access the output tag
- name: Use the verified tag
  run: |
    echo "Tag: ${{ steps.verify_tag.outputs.tag }}"
```

