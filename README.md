# Core-Execution-Logic-NVMe-Cryptographic-Erase
Bash-driven automated data sanitization and resilience pipeline for enterprise NVMe/SATA SSDs.

## nvme_crypto_erase.sh

Performs a firmware-level **Cryptographic Erase** (SES=1) on a target NVMe namespace using the `nvme-cli` `format` command.

### Prerequisites

- Linux with `nvme-cli` installed (`sudo apt install nvme-cli` or equivalent)
- `sudo` / root privileges

### Usage

```bash
# Erase the default drive /dev/nvme0n1
sudo ./nvme_crypto_erase.sh

# Erase a specific NVMe namespace
sudo ./nvme_crypto_erase.sh /dev/nvme1n1
```

### What it does

1. Validates the target block device exists.
2. Prints the drive topology via `lsblk` and `nvme list`.
3. Issues `nvme format <device> --ses=1` to destroy all data and cryptographic keys irretrievably.

> **WARNING:** This operation is **irreversible**. All data on the target drive will be permanently destroyed.
