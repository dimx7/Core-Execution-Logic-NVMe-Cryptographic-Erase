#!/bin/bash
# Enterprise Device Decommissioning - Core Wipe Logic
# Target: NVMe Solid State Drives
# Default Execution: Secure Erase (SES=1)
# Optional Execution: Cryptographic Erase (SES=2) if supported by controller

set -euo pipefail

usage() {
    cat <<'EOF'
Usage:
  nvme-crypto-erase.sh [TARGET_DRIVE] [--ses=1|2]

Examples:
  nvme-crypto-erase.sh
  nvme-crypto-erase.sh /dev/nvme0n1
  nvme-crypto-erase.sh /dev/nvme1n1 --ses=2

Policy:
  Default mode is --ses=1 (secure erase).
  --ses=2 (cryptographic erase) is optional and depends on device/controller support.
EOF
}

TARGET_DRIVE="/dev/nvme0n1"
SES_VALUE="1"   # default per policy

# Parse args (order-independent)
for arg in "$@"; do
    case "$arg" in
        --ses=1|--ses=2)
            SES_VALUE="${arg#--ses=}"
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        /dev/*)
            TARGET_DRIVE="$arg"
            ;;
        *)
            echo "ERROR: Unknown argument: $arg" >&2
            usage
            exit 1
            ;;
    esac
done

echo "Validating target drive: $TARGET_DRIVE"
if [ ! -b "$TARGET_DRIVE" ]; then
    echo "ERROR: $TARGET_DRIVE is not a valid block device." >&2
    exit 1
fi

lsblk | grep "$(basename "$TARGET_DRIVE")" || true

echo ""
echo "NVMe device topology:"
sudo nvme list

echo ""
echo "WARNING: This operation destroys all data irretrievably."
if [ "$SES_VALUE" = "1" ]; then
    echo "Selected mode: SES=1 (Secure Erase - default)"
else
    echo "Selected mode: SES=2 (Cryptographic Erase - optional, device support required)"
fi

echo ""
echo "Initiating NVMe format on $TARGET_DRIVE with --ses=$SES_VALUE ..."
if sudo nvme format "$TARGET_DRIVE" --ses="$SES_VALUE"; then
    echo "Erase completed successfully on $TARGET_DRIVE with --ses=$SES_VALUE."
else
    if [ "$SES_VALUE" = "2" ]; then
        echo "ERROR: SES=2 (Cryptographic Erase) failed or is not supported on $TARGET_DRIVE." >&2
        echo "Use default secure erase mode (--ses=1) for broad compatibility." >&2
    else
        echo "ERROR: SES=1 (Secure Erase) failed on $TARGET_DRIVE." >&2
    fi
    exit 1
fi
