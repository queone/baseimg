#!/usr/bin/env bash

set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <package-name> <version>"
  exit 1
fi

PACKAGE_NAME=$1
VERSION=$2
USERNAME="queone"
TOKEN="${GH_TOKEN}"

if [ -z "$TOKEN" ]; then
  echo "Error: GH_TOKEN is not set."
  exit 1
fi

# Fetch package versions
RESPONSE=$(curl -s -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/orgs/$USERNAME/packages/container/$PACKAGE_NAME/versions")

echo "API Response: $RESPONSE"

# Find the specific version ID
VERSION_ID=$(echo "$RESPONSE" | jq -r --arg VERSION "$VERSION" '.[] | select(.name == $VERSION) | .id')

if [[ -z "$VERSION_ID" ]]; then
  echo "No image found for version: $VERSION"
  exit 1
fi

# Delete the specific version
echo "Deleting image ID: $VERSION_ID for version: $VERSION"
curl -X DELETE -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/orgs/$USERNAME/packages/container/$PACKAGE_NAME/versions/$VERSION_ID"

echo "Version $VERSION of package $PACKAGE_NAME deleted successfully."

# Delete the package itself
echo "Deleting package: $PACKAGE_NAME"
curl -X DELETE -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/orgs/$USERNAME/packages/container/$PACKAGE_NAME"

echo "Package $PACKAGE_NAME deleted successfully."

# Remove the Git tag
echo "Removing Git tag: $VERSION"
git tag -d "$VERSION" || echo "Tag $VERSION not found locally."
git push --delete origin "$VERSION" || echo "Tag $VERSION not found on remote."
