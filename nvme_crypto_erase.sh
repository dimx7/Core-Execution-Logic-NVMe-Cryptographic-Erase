#!/bin/bash
# Enterprise Device Decommissioning - Core Wipe Logic
# Target: NVMe Solid State Drives
# Execution: Firmware-level Cryptographic Erase (SES=1)

set -euo pipefail

# 1. Identify Target NVMe Namespace
TARGET_DRIVE="${1:-/dev/nvme0n1}"
echo "Validating target drive: $TARGET_DRIVE"

if [ ! -b "$TARGET_DRIVE" ]; then
    echo "ERROR: $TARGET_DRIVE is not a valid block device." >&2
    exit 1
fi

lsblk | grep "$(basename "$TARGET_DRIVE")" || true

# 2. List NVMe devices and topology
echo ""
echo "NVMe device topology:"
sudo nvme list

# 3. Execute Secure Erase (SES=1: Cryptographic Erase)
# WARNING: This operation destroys all data and cryptographic keys irretrievably.
echo ""
echo "Initiating Firmware-Level Secure Erase on $TARGET_DRIVE..."
if sudo nvme format "$TARGET_DRIVE" --ses=1; then
    # Expected Output: Success formatting namespace:1
    echo "Secure erase completed successfully on $TARGET_DRIVE."
else
    echo "ERROR: nvme format failed on $TARGET_DRIVE. Verify the device supports cryptographic erase (SES=1) and that you have sufficient privileges." >&2
    exit 1
fi
