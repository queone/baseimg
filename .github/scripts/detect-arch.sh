#!/usr/bin/env bash
# detect-arch.sh

set -euo pipefail
Gre='\e[1;32m' Red='\e[1;31m' Yel='\e[1;33m' Rst='\e[0m'

# Check for correct number of arguments
if [[ $# -ne 2 ]]; then
  printf "Usage: ${Yel}$0${Rst} <image_url_path> <image_tag>\n"
  exit 1
fi

IMAGE="$1:$2"

# Inspect the image and extract manifests
INSPECT=$(docker buildx imagetools inspect --raw "$IMAGE" 2>&1 || true)
MANIFESTS=$(echo "$INSPECT" | jq -c '.manifests // []')

# Default architecture if no manifests are found
if [[ "$MANIFESTS" == "[]" ]]; then
  printf '["linux/amd64"]' # Output JSON array directly
else
  # Extract valid platforms and format as a JSON array
  echo "$MANIFESTS" | jq -c '[.[] | select(.platform.architecture != "unknown" and .platform.os != "unknown") | "\(.platform.os)/\(.platform.architecture)"]'
fi

exit 0
