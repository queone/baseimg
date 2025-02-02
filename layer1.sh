#!/usr/bin/env bash
# layer1.sh

set -euo pipefail

# ---------------------------------------
# Install required packages
microdnf update -y
microdnf install -y \
tar \
git \
glibc \
python3-libs \
python3.12 \
python3.12-devel \
python3.12-pip \
jq \
which \
iputils \
iproute
# Append/add other required packages here
microdnf clean all
rm -rf /var/cache/dnf/*

# ---------------------------------------
# Set up Python 3.12 as default
# Set up python links
alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1
alternatives --install /usr/bin/python python /usr/bin/python3.12 1
alternatives --set python3 /usr/bin/python3.12
alternatives --set python /usr/bin/python3.12
# Set up pip links
alternatives --install /usr/bin/pip3 pip3 /usr/bin/pip3.12 1
alternatives --install /usr/bin/pip pip /usr/bin/pip3.12 1
alternatives --set pip3 /usr/bin/pip3.12
alternatives --set pip /usr/bin/pip3.12
# Update pip and process requirements.txt
pip install --upgrade pip
pip install -r /tmp/requirements.txt

exit 0
