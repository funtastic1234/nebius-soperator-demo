# Complete Deployment and Execution Guide

This guide walks you through the **complete** deployment and execution of the Nebius Soperator demo.

## Prerequisites Check

First, let's check what you have installed:

```bash
which terraform nebius kubectl yq jq
```

If any are missing, install them:

```bash
# macOS
brew install terraform kubectl yq jq

# Nebius CLI - follow: https://nebius.com/docs/cli/quickstart
```

## Step 1: Get Nebius Credentials

** EASIEST WAY: Run the interactive script:**
```bash
cd /Users/admin/Desktop/nebius-assignment
./get-credentials.sh
```

This will guide you through:
- Finding your Tenant ID
- Authenticating with Nebius
- Getting your IAM token
- Saving credentials for later use

---

**OR follow these manual steps:**

You need:
1. **NEBIUS_TENANT_ID** - From Nebius Console (starts with `tenant-`)
2. **NEBIUS_PROJECT_ID** - `project-e00pr6smpr00520mtjnf6q` (from assignment)
3. **IAM Token** - Generated via Nebius CLI

### Finding Your Tenant ID

1. **Access Nebius Console:**
   - Go to: https://console.nebius.com
   - Or use the invitation link from your email
   - Log in with your credentials

2. **Find Tenant ID:**
   - Look at the URL: `https://console.nebius.com/tenant-XXXXX/...`
   - Or click your profile icon → Look for "Tenant" or "Organization"
   - The tenant ID starts with `tenant-`

3. **Access your project:**
   - URL: https://console.nebius.com/project-e00pr6smpr00520mtjnf6q
   - Or navigate via the console UI

### Getting IAM Token

### Option A: Using Nebius CLI (Recommended)

```bash
# Install Nebius CLI first (if not installed)
# Follow: https://nebius.com/docs/cli/quickstart

# Authenticate (opens browser)
nebius iam token create

# Verify authentication
nebius iam whoami

# Get token
export NEBIUS_TENANT_ID="tenant-<your-tenant-id>"  # From console
export NEBIUS_PROJECT_ID="project-e00pr6smpr00520mtjnf6q"
export NEBIUS_IAM_TOKEN=$(nebius iam get-access-token)
```

### Option B: Manual Setup

If you don't have Nebius CLI:
1. Go to Nebius Console → IAM → Service Accounts
2. Create a service account (if needed)
3. Generate an API key
4. Download JSON key file
5. Use the key file or extract token from it

## Step 2: Automated Deployment

Run the deployment script:

```bash
cd /Users/admin/Desktop/nebius-assignment
./deploy-full-solution.sh
```

This script will:
- ✓ Check prerequisites
- ✓ Set up Nebius access
- ✓ Configure Terraform
- ✓ Deploy the cluster (~40 minutes)
- ✓ Get connection information

**OR** deploy manually:

## Step 2 (Manual): Deploy Cluster

```bash
cd /Users/admin/Desktop/nebius-assignment/soperator/installations/demo

# Set environment variables
export NEBIUS_TENANT_ID="tenant-<your-tenant-id>"
export NEBIUS_PROJECT_ID="project-e00pr6smpr00520mtjnf6q"
export NEBIUS_IAM_TOKEN=$(nebius iam get-access-token)

# Source .envrc (sets up service account, VPC, etc.)
source .envrc

# Initialize Terraform
terraform init

# Review configuration
cat terraform.tfvars | grep -E "(company_name|infiniband_fabric|public_o11y_enabled|size)"

# Deploy (takes ~40 minutes)
terraform apply
```

## Step 3: Connect to Cluster

After deployment completes:

```bash
# Get login node IP
cd /Users/admin/Desktop/nebius-assignment/soperator/installations/demo
export SLURM_IP=$(terraform output -raw slurm_login_ip 2>/dev/null || \
  terraform state show module.login_script.terraform_data.lb_service_ip | \
  grep 'input' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)

# Connect
ssh root@$SLURM_IP -i ~/.ssh/id_ed25519
```

## Step 4: Upload Demo Scripts

On your local machine:

```bash
cd /Users/admin/Desktop/nebius-assignment
tar -czf /tmp/demo-scripts.tar.gz \
  soperator/installations/demo/training \
  soperator/installations/demo/inference \
  soperator/installations/demo/comparison \
  soperator/installations/demo/monitoring

# Upload to cluster
scp -i ~/.ssh/id_ed25519 /tmp/demo-scripts.tar.gz root@$SLURM_IP:/opt/
```

On the cluster:

```bash
# Extract scripts
cd /opt
tar -xzf demo-scripts.tar.gz
mv soperator/installations/demo /opt/demo

# Create directories
mkdir -p /mnt/training/{data,checkpoints,models}
mkdir -p /mnt/inference/{models,results,original,test_data}

# Make scripts executable
chmod +x /opt/demo/training/*.sh
chmod +x /opt/demo/inference/*.sh
chmod +x /opt/demo/monitoring/*.sh
chmod +x /opt/demo/comparison/*.py
```

## Step 5: Execute Workflows

### Option A: Automated Execution

On the cluster, run:

```bash
/opt/demo/execute-workflows.sh
```

This will run all workflows automatically.

### Option B: Manual Execution

#### 5.1: Run Distributed Training

```bash
cd /opt/demo/training
sbatch train_job.sh
```

Monitor:
```bash
# Check job status
squeue

# Watch output
tail -f training-*.out

# Check GPU utilization
watch -n 5 /opt/demo/monitoring/check_gpu_util.sh
```

#### 5.2: Run Inference on Trained Model

After training completes:

```bash
cd /opt/demo/inference
sbatch inference_trained.sh
```

Monitor:
```bash
squeue
tail -f inference-trained-*.out
```

#### 5.3: Run Inference on Original Model

```bash
cd /opt/demo/inference
sbatch inference_original.sh
```

Monitor:
```bash
squeue
tail -f inference-original-*.out
```

#### 5.4: Compare Models

After both inference jobs complete:

```bash
cd /opt/demo/comparison
python3 compare_models.py \
  --trained-results /mnt/inference/results/trained/inference_results.json \
  --original-results /mnt/inference/results/original/inference_results.json \
  --output /mnt/inference/results/comparison_report.json
```

View results:
```bash
cat /mnt/inference/results/comparison_report.json
```

#### 5.5: Monitor GPU Utilization

```bash
# Real-time check
/opt/demo/monitoring/check_gpu_util.sh

# Continuous monitoring
/opt/demo/monitoring/monitor_gpus.sh
```

## Step 6: Verify Requirements

### ✓ 16x H100s (2 nodes × 8 GPUs)
```bash
sinfo -N -o "%N %G"
```

### ✓ >80% GPU Utilization
```bash
/opt/demo/monitoring/check_gpu_util.sh
```

### ✓ Training and Inference on Same Cluster
Both jobs run on the same K8s cluster deployed by Terraform.

### ✓ Model Comparison
Results saved to `/mnt/inference/results/comparison_report.json`

## Troubleshooting

### Deployment Issues

1. **"Not Enough Resources"**
   - Verify `infiniband_fabric = "fabric-6"` in terraform.tfvars
   - Check capacity limits in Nebius console

2. **Terraform Init Fails**
   - Check Nebius CLI is authenticated: `nebius iam whoami`
   - Verify environment variables are set

3. **SSH Connection Fails**
   - Verify SSH key in terraform.tfvars matches your public key
   - Check login node IP: `terraform output`

### Execution Issues

1. **Low GPU Utilization**
   - Check job allocation: `scontrol show job <job_id>`
   - Verify all GPUs requested: `--gres=gpu:8`

2. **Scripts Not Found**
   - Verify scripts uploaded: `ls -la /opt/demo/`
   - Re-upload if needed

3. **Model Loading Errors**
   - Check model paths: `ls -lh /mnt/training/models/`
   - Verify training completed successfully

## Quick Reference

```bash
# Deploy
cd soperator/installations/demo
source .envrc
terraform apply

# Connect
ssh root@$SLURM_IP -i ~/.ssh/id_ed25519

# Run training
cd /opt/demo/training && sbatch train_job.sh

# Monitor
watch -n 5 /opt/demo/monitoring/check_gpu_util.sh

# Run inference
cd /opt/demo/inference && sbatch inference_trained.sh && sbatch inference_original.sh

# Compare
cd /opt/demo/comparison && python3 compare_models.py ...
```

## Next Steps

1. ✓ Deploy cluster
2. ✓ Upload scripts
3. ✓ Run training
4. ✓ Run inference
5. ✓ Compare models
6. ✓ Monitor GPU utilization
7. **Keep environment running** for demo day!

## Important Notes

-  **DO NOT DESTROY** the lab environment
- ✓ Use **fabric-6** for GPU cluster
- ✓ Set **public_o11y_enabled = false**
- ✓ Use **separate filesystems** for training and inference
- ✓ Monitor GPU utilization to ensure **>80%**

