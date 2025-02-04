#!/usr/bin/env bash
# detect-arch.sh

set -euo pipefail

IMAGE="$1:$2"

echo "Inspecting image: $IMAGE"

# Check if the image exists
if ! docker buildx imagetools inspect "$IMAGE" > /tmp/image_inspect.json 2>/dev/null; then
  echo "❌ Image $IMAGE does not exist or is not accessible!"
  exit 1
fi

# Extract architectures using jq (more robust)
ARCHS=$(jq -r '.manifests[].platform | select(.architecture) | "linux/" + .architecture' /tmp/image_inspect.json | sort -u | tr '\n' ' ')

# Handle single-arch images (if no architectures found)
if [[ -z "$ARCHS" ]]; then
  echo "⚠️ No architectures found in manifest. Assuming single-arch (linux/amd64)."
  ARCHS="linux/amd64"
fi

echo "Detected architectures: $ARCHS"
echo "archs=$ARCHS" >> "$GITHUB_OUTPUT"
