# Core-Execution-Logic-NVMe-Cryptographic-Erase
Bash-driven automated data sanitization and resilience pipeline for enterprise NVMe/SATA SSDs.
# Enterprise Asset Decommissioning & Data Resilience Pipeline

## Overview
An automated bash-based framework designed for Linux (Zorin OS / Ubuntu derivatives) to execute secure data sanitization and disaster recovery protocols. The objective is binary: eliminate data remanence risks during hardware decommissioning and ensure zero data loss during production upgrades.

## Core Capabilities
* **Firmware-Level Cryptographic Erase:** Executes `SES=1` or `SES=2` (Secure Erase Setting) via `nvme-cli`, permanently destroying cryptographic keys and rendering all data on NVMe drives irrecoverable.
* **Hardware Detection Logic:** Validates the target drive (`/dev/nvmeXnY`) before execution to prevent accidental data destruction on active system drives.
* **Data Resilience (Backup/Restore):** Parallel bash routines designed to securely clone and restore production states across enterprise environments, minimizing RTO (Recovery Time Objective).

## Operational Impact & Compliance
By enforcing strict sanitization protocols at the firmware level, this pipeline:
1. Neutralizes the risk of data exfiltration and ransomware exposure from retired hardware.
2. Ensures compliance with enterprise data destruction policies and GDPR requirements prior to third-party hardware resale.

## Prerequisites
* Linux OS (Tested on Zorin OS / Ubuntu)
* Root (`sudo`) privileges
* `nvme-cli` installed (`sudo apt install nvme-cli`)

## Execution (Secure Wipe)

> ⚠️ **CRITICAL WARNING:** The secure erase script is destructive. Executing the cryptographic wipe will result in permanent, irrecoverable data loss. Validate your target disk (`lsblk`) before execution.

```bash
# 1. Clone the repository
git clone [https://github.com/dimx7/secure-wipe-pipeline.git](https://github.com/dimx7/secure-wipe-pipeline.git)

# 2. Make the script executable
chmod +x core_nvme_secure_erase.sh

# 3. Execute with root privileges
sudo ./core_nvme_secure_erase.sh
