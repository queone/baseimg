#!/usr/bin/env bash
# layer1.sh

# ---------------------------------------
# Install required packages
microdnf install -y \
curl \
git
microdnf clean all

