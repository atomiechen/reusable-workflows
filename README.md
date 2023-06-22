# reusable-workflows

Resuable workflows.

## Publish python distributions

`atomiechen/reusable-workflows/.github/workflows/publish-python-distributions.yml@main`

```yaml
    inputs:
      publish_testpypi:
        type: boolean
        default: false
        description: Publish to TestPyPI
      publish_pypi:
        type: boolean
        default: false
        description: Publish to PyPI
      publish_gh_release:
        type: boolean
        default: true
        description: Publish to GitHub Release
      release_tag:
        type: string
        description: Tag to package (empty for latest tag)
        required: false
    secrets:
      TEST_PYPI_API_TOKEN:
        required: true
      PYPI_API_TOKEN:
        required: true
```

