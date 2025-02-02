#!/usr/bin/env bash
# extract-image-name.sh

set -euo pipefail
Gre='\e[1;32m' Red='\e[1;31m' Pur='\e[1;35m' Yel='\e[1;33m' Blu='\e[1;34m' Rst='\e[0m'

# Check if a Dockerfile argument is provided
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

# Extract and clean the "name" label
IMAGE_NAME=$(echo "$LABEL_CONTENT" | grep -oE 'name=[^ ]+' | cut -d'=' -f2 | tr -d ' "')

# Output only the image name (without "IMAGE_NAME=" prefix)
if [[ -n "$IMAGE_NAME" ]]; then
    echo "$IMAGE_NAME"
else
    printf "${Red}No 'name' label found.${Rst}\n"
    exit 1
fi
