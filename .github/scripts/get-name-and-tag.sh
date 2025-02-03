#!/usr/bin/env bash
# get-name-and-tag.sh

set -euo pipefail
Gre='\e[1;32m' Red='\e[1;31m' Pur='\e[1;35m' Yel='\e[1;33m' Blu='\e[1;34m' Rst='\e[0m'

# Ensure a Dockerfile argument is provided
[[ $# -ne 1 ]] && { echo "Usage: $0 <Dockerfile>"; exit 1; }

DOCKERFILE=$1
LABEL_CONTENT=""

# Read and concatenate multi-line LABEL statements
while IFS= read -r line; do
    # Trim leading and trailing whitespace
    line=$(echo "$line" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')

    # If the line starts with LABEL, begin capturing its content
    if [[ "$line" =~ ^LABEL[[:space:]] ]]; then
        LABEL_CONTENT="${line#LABEL }"
        continue
    fi

    # If inside a LABEL block, continue appending lines that end with a backslash
    if [[ -n "$LABEL_CONTENT" ]]; then
        LABEL_CONTENT+="${line%\\} "
        if [[ ! "$line" =~ \\$ ]]; then
            break
        fi
    fi
done < "$DOCKERFILE"

# Extract and clean the OCI-compliant "org.opencontainers.image.title" label (image name)
IMAGE_NAME=$(echo "$LABEL_CONTENT" | grep -oE 'org.opencontainers.image.title=[^ ]+' | cut -d'=' -f2 | tr -d ' "')

# Extract and clean the OCI-compliant "org.opencontainers.image.version" label (image tag)
IMAGE_TAG=$(echo "$LABEL_CONTENT" | grep -oE 'org.opencontainers.image.version=[^ ]+' | cut -d'=' -f2 | tr -d ' "')

# Validate extracted values
if [[ -z "$IMAGE_NAME" ]]; then
    printf "${Red}Error: No 'org.opencontainers.image.title' label found.${Rst}\n"
    exit 1
fi

if [[ -z "$IMAGE_TAG" ]]; then
    IMAGE_TAG="latest"  # Default to "latest" if no tag is found
fi

# Print both values on the same line to prevent `read` issues
printf "%s %s\n" "$IMAGE_NAME" "$IMAGE_TAG"
