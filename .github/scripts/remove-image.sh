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

# Find the specific version ID by checking the tags
VERSION_ID=$(echo "$RESPONSE" | jq -r --arg VERSION "$VERSION" '.[] | select(.metadata.container.tags | index($VERSION)) | .id')

if [[ -z "$VERSION_ID" ]]; then
  echo "No image found for version: $VERSION"
  exit 1
fi

# Count the number of versions
VERSION_COUNT=$(echo "$RESPONSE" | jq -r '. | length')

# Delete the specific version
echo "Deleting image ID: $VERSION_ID for version: $VERSION"
curl -X DELETE -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/orgs/$USERNAME/packages/container/$PACKAGE_NAME/versions/$VERSION_ID"

echo "Version $VERSION of package $PACKAGE_NAME deleted successfully."

# Check if this was the last version
if [[ $VERSION_COUNT -eq 1 ]]; then
  # Delete the package itself
  echo "Deleting package: $PACKAGE_NAME"
  curl -X DELETE -H "Authorization: Bearer $TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/orgs/$USERNAME/packages/container/$PACKAGE_NAME"

  echo "Package $PACKAGE_NAME deleted successfully."
else
  echo "Package $PACKAGE_NAME not deleted because other versions exist."
fi
