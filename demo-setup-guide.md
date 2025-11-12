# Nebius Demo Setup Guide

## Prerequisites

1. Install required tools:
   - Terraform (>=1.8.0)
   - Nebius CLI
   - kubectl
   - yq
   - jq

2. Install yq (if not already installed):
   ```bash
   # macOS
   brew install yq
   
   # Linux
   wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/local/bin/yq
   chmod +x /usr/local/bin/yq
   ```

## Setting Up Nebius Access

### Option 1: Using Nebius CLI (Recommended)

1. Install Nebius CLI following the [official guide](https://nebius.com/docs/cli/quickstart)

2. Authenticate:
   ```bash
   nebius iam token create
   ```

3. Set environment variables:
   ```bash
   export NEBIUS_TENANT_ID="tenant-<your-tenant-id>"
   export NEBIUS_PROJECT_ID="project-e00pr6smpr00520mtjnf6q"
   ```

4. Verify access:
   ```bash
   nebius iam whoami
   ```

### Option 2: Using SDK/API

If you prefer to use the SDK, you can provide me with:
- Service account credentials (JSON key file)
- Or API token

I can then configure the Terraform providers to use these credentials.

## Deployment Steps

1. Navigate to the installation directory:
   ```bash
   cd soperator/installations/demo
   ```

2. Configure environment (if using .envrc):
   ```bash
   source .envrc
   ```

3. Initialize Terraform:
   ```bash
   terraform init
   ```

4. Review and customize `terraform.tfvars`:
   - Set `company_name`
   - Set `infiniband_fabric = "fabric-6"` (required!)
   - Set `public_o11y_enabled = false` (required!)
   - Configure SSH keys
   - Configure separate filesystems for training and inference

5. Deploy the cluster:
   ```bash
   terraform apply
   ```

   This will take approximately 40 minutes for a 2-node GPU cluster.

6. Get cluster connection details:
   ```bash
   export SLURM_IP=$(terraform output -raw slurm_login_ip)
   ssh root@$SLURM_IP -i ~/.ssh/<your-private-key>
   ```

## Running the Demo

See `demo-workflows.md` for detailed instructions on:
- Running distributed training/fine-tuning
- Running inference on trained model
- Running inference on original model
- Comparing results
- Monitoring GPU utilization

