#!/usr/bin/env bash
# remove-image.sh

set -euo pipefail
Gre='\e[1;32m' Red='\e[1;31m' Mag='\e[1;35m' Yel='\e[1;33m' Blu='\e[1;34m' Rst='\e[0m'

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <package-name> <tag>"
  exit 1
fi

PACKAGE_NAME=$1
TAG=$2
USERNAME="queone"
TOKEN="${GH_TOKEN}"

if [[ -z "$TOKEN" ]]; then
  printf "${Red}Error: GH_TOKEN is not set.${Rst}\n"
  exit 1
fi

# Fetch package tags
RESPONSE=$(curl -s -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/orgs/$USERNAME/packages/container/$PACKAGE_NAME/versions")

printf "${Yel}API Response: $RESPONSE${Rst}\n"

# Find the specific tag ID by checking the tags
TAG_ID=$(echo "$RESPONSE" | jq -r --arg TAG "$TAG" \
  '.[] | select(.metadata.container.tags | index($TAG)) | .id')

if [[ -z "$TAG_ID" ]]; then
  printf "${Yel}No image found for tag: $TAG${Rst}\n"
  exit 1
fi

# Count only images that have at least one tag
TAG_COUNT=$(echo "$RESPONSE" | jq -r '[.[] | select(.metadata.container.tags | length > 0)] | length')

# Delete the specific tag
echo "Deleting image ID: $TAG_ID for tag: $TAG"
curl -X DELETE -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/orgs/$USERNAME/packages/container/$PACKAGE_NAME/versions/$TAG_ID"

printf "${Yel}Tag $TAG of package $PACKAGE_NAME deleted successfully.${Rst}\n"

# Check if there are any remaining tagged images
if [[ $TAG_COUNT -eq 1 ]]; then
  echo "Deleting package: $PACKAGE_NAME"
  curl -X DELETE -H "Authorization: Bearer $TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/orgs/$USERNAME/packages/container/$PACKAGE_NAME"

  printf "${Yel}Package $PACKAGE_NAME deleted successfully.${Rst}\n"
else
  printf "${Yel}Package $PACKAGE_NAME not deleted because other tagged images exist.${Rst}\n"
fi

# Remove untagged images (dangling images)
UNTAGGED_IDS=$(echo "$RESPONSE" | jq -r '.[] | select(.metadata.container.tags | length == 0) | .id')

for ID in $UNTAGGED_IDS; do
  echo "Deleting untagged image ID: $ID"
  curl -X DELETE -H "Authorization: Bearer $TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/orgs/$USERNAME/packages/container/$PACKAGE_NAME/versions/$ID"
done
