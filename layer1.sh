#!/usr/bin/env bash
# layer1.sh

set -euo pipefail
# ---------------------------------------
# Install required packages
microdnf update -y
microdnf install -y \
git
microdnf clean all

