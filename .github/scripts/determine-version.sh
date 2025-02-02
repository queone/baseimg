#!/usr/bin/env bash
# determine-version.sh

set -euo pipefail

# Check if a tag name is provided via environment variable (GitHub Actions input)
if [[ -n "${GITHUB_TAG_NAME:-}" ]]; then
    echo "$GITHUB_TAG_NAME"
else
    # Fetch latest tags from GitHub
    git fetch --tags

    # Get latest tag, filtering only valid semver tags
    LATEST_TAG=$(git tag --sort=-v:refname | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | head -n1 || true)

    if [[ -z "$LATEST_TAG" ]]; then
        echo "1.0.0"
    else
        IFS='.' read -r MAJOR MINOR PATCH <<< "$LATEST_TAG"
        PATCH=$((PATCH + 1))
        echo "$MAJOR.$MINOR.$PATCH"
    fi
fi
