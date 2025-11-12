# Full Deployment Walkthrough

This guide will walk you through deploying and executing the complete solution.

## Step 1: Install Prerequisites

### Install Terraform
```bash
# macOS
brew install terraform

# Or download from: https://www.terraform.io/downloads
```

### Install Nebius CLI
```bash
# Follow: https://nebius.com/docs/cli/quickstart
# Or use:
curl -sSL https://nebius.com/docs/cli/install.sh | bash
```

### Install yq
```bash
brew install yq
```

## Step 2: Get Your SSH Public Key

Your SSH key is at: `~/.ssh/id_ed25519.pub`

We'll use this in the Terraform configuration.

## Step 3: Set Up Nebius Access

You need:
- **NEBIUS_TENANT_ID**: From Nebius Console (starts with `tenant-`)
- **NEBIUS_PROJECT_ID**: `project-e00pr6smpr00520mtjnf6q` (from assignment)
- **IAM Token**: Generated via Nebius CLI

### Option A: Using Nebius CLI
```bash
# Install Nebius CLI first
# Then authenticate
nebius iam token create

# Set environment variables
export NEBIUS_TENANT_ID="tenant-<your-tenant-id>"
export NEBIUS_PROJECT_ID="project-e00pr6smpr00520mtjnf6q"
export NEBIUS_IAM_TOKEN=$(nebius iam get-access-token)

# Verify
nebius iam whoami
```

### Option B: Using Service Account (SDK)
If you have a service account JSON key file, we can use that instead.

## Step 4: Configure Terraform

1. Update `terraform.tfvars` with your SSH public key
2. Verify all settings are correct

## Step 5: Deploy Cluster

```bash
cd soperator/installations/demo
terraform init
terraform apply
```

## Step 6: Connect and Upload Scripts

## Step 7: Execute Workflows

