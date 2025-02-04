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
  ARCHS="linux/amd64" # Assume Linux X86_64
else
  # Extract valid platforms
  ARCHS=$(echo "$MANIFESTS" | jq -r '.[] | select(.platform.architecture != "unknown" and .platform.os != "unknown") | "\(.platform.os)/\(.platform.architecture)"' | xargs)
fi

# Print the architectures
printf "$ARCHS" # Without newline so it works when passed to $GITHUB_OUTPUT in the workflow
exit 0
