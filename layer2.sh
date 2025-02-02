#!/usr/bin/env bash
# layer2.sh

set -euo pipefail

# ---------------------------------------
# Create a new repo file for HashiCorp and install Vault
cat <<EOF > /etc/yum.repos.d/hashicorp.repo
[hashicorp]
name=HashiCorp Stable
baseurl=https://rpm.releases.hashicorp.com/RHEL/9/x86_64/stable
enabled=1
gpgcheck=1
gpgkey=https://rpm.releases.hashicorp.com/gpg
EOF
#microdnf repoquery vault # To search available
microdnf update -y
microdnf install -y libcap vault-1.18.4 # Needed by Vault
microdnf clean all
rm -rf /var/cache/dnf/*
# Vault requires IPC_LOCK capability for memory locking
setcap cap_ipc_lock=+ep /usr/bin/vault

exit 0
