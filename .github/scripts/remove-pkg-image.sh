#!/usr/bin/env bash

set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <package-name>"
  exit 1
fi

PACKAGE_NAME=$1
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

IMAGES=$(echo "$RESPONSE" | jq -r 'map(select(.id)) | .[].id')

if [[ -z "$IMAGES" ]]; then
  echo "No images found."
else
  for IMAGE_ID in $IMAGES; do
    echo "Deleting image ID: $IMAGE_ID"
    curl -X DELETE -H "Authorization: Bearer $TOKEN" \
      -H "Accept: application/vnd.github.v3+json" \
      "https://api.github.com/orgs/$USERNAME/packages/container/$PACKAGE_NAME/versions/$IMAGE_ID"
  done
fi

# Delete the package itself
echo "Deleting package: $PACKAGE_NAME"
curl -X DELETE -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/orgs/$USERNAME/packages/container/$PACKAGE_NAME"

echo "Package $PACKAGE_NAME deleted successfully."
