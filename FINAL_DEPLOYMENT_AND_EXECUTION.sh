#!/bin/bash
# Complete deployment and execution script
# This script completes the Terraform deployment and executes the full workflow

set -e

echo "=========================================="
echo "Nebius Soperator - Complete Deployment & Execution"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Configuration
DEMO_DIR="/Users/admin/Desktop/nebius-assignment"
TERRAFORM_DIR="${DEMO_DIR}/soperator/installations/demo"
TERRAFORM_VERSION="1.8.5"

# Step 1: Setup environment
echo -e "${YELLOW}Step 1: Setting up environment...${NC}"
export PATH="/Users/admin/.config/tfenv/versions/${TERRAFORM_VERSION}:$PATH"
export PATH="$HOME/.nebius/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"

cd "$TERRAFORM_DIR"
source ~/.nebius_encrypted_credentials.sh 2>/dev/null || echo "Warning: Credentials not found"
source .envrc 2>/dev/null || echo "Warning: .envrc not found"

# Verify Terraform version
TERRAFORM_VER=$(terraform version -json | grep -o '"terraform_version":"[^"]*' | cut -d'"' -f4)
echo "Terraform version: $TERRAFORM_VER"
if [[ ! "$TERRAFORM_VER" =~ ^1\.8\. ]]; then
    echo -e "${RED}ERROR: Terraform 1.8.x required, found $TERRAFORM_VER${NC}"
    echo "Switching to Terraform 1.8.5..."
    tfenv use 1.8.5
fi

# Step 2: Initialize Terraform
echo ""
echo -e "${YELLOW}Step 2: Initializing Terraform...${NC}"
terraform init -reconfigure

# Step 3: Validate configuration
echo ""
echo -e "${YELLOW}Step 3: Validating configuration...${NC}"
if ! terraform validate; then
    echo -e "${RED}Validation failed. Please fix errors before proceeding.${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Configuration valid${NC}"

# Step 4: Deploy infrastructure
echo ""
echo -e "${YELLOW}Step 4: Deploying infrastructure (this will take 20-40 minutes)...${NC}"
echo "This will deploy:"
echo "  - Slurm components via Helm/FluxCD"
echo "  - Slurm controller and login nodes"
echo "  - Worker node configuration"
echo ""
read -p "Press Enter to continue or Ctrl+C to cancel..."

terraform apply -auto-approve

# Step 5: Get cluster access information
echo ""
echo -e "${YELLOW}Step 5: Getting cluster access information...${NC}"
LOGIN_IP=$(terraform output -raw slurm_login_ip 2>/dev/null || \
    cat ./login.sh 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -1)

if [ -z "$LOGIN_IP" ]; then
    echo -e "${RED}Could not determine login IP. Please check terraform output.${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Login node IP: $LOGIN_IP${NC}"

# Step 6: Wait for cluster to be ready
echo ""
echo -e "${YELLOW}Step 6: Waiting for cluster to be ready...${NC}"
echo "Checking Slurm status..."

# Try to SSH and check Slurm
SSH_KEY="${HOME}/.ssh/id_rsa"
if [ ! -f "$SSH_KEY" ]; then
    SSH_KEY="${HOME}/.ssh/id_ed25519"
fi

if [ -f "$SSH_KEY" ]; then
    echo "Attempting to connect to cluster..."
    ssh -o StrictHostKeyChecking=no -i "$SSH_KEY" root@"$LOGIN_IP" "sinfo" 2>/dev/null && \
        echo -e "${GREEN}✓ Cluster is ready!${NC}" || \
        echo -e "${YELLOW}Cluster may still be initializing. Please check manually.${NC}"
else
    echo -e "${YELLOW}SSH key not found. Please connect manually:${NC}"
    echo "  ssh root@$LOGIN_IP"
fi

# Step 7: Instructions for next steps
echo ""
echo "=========================================="
echo -e "${GREEN}Deployment Complete!${NC}"
echo "=========================================="
echo ""
echo "Next steps:"
echo ""
echo "1. SSH into the cluster:"
echo "   ssh root@$LOGIN_IP -i $SSH_KEY"
echo ""
echo "2. Upload training scripts:"
echo "   scp -r ${DEMO_DIR}/soperator/installations/demo/training root@$LOGIN_IP:/opt/demo/"
echo "   scp -r ${DEMO_DIR}/soperator/installations/demo/inference root@$LOGIN_IP:/opt/demo/"
echo "   scp -r ${DEMO_DIR}/soperator/installations/demo/comparison root@$LOGIN_IP:/opt/demo/"
echo ""
echo "3. Run training (saves original model first):"
echo "   cd /opt/demo/training"
echo "   sbatch train_with_original_save.sh"
echo ""
echo "4. Monitor training:"
echo "   squeue"
echo "   watch -n 5 nvidia-smi"
echo ""
echo "5. After training, run comparison:"
echo "   cd /opt/demo/comparison"
echo "   bash run_full_comparison.sh"
echo ""
echo "For detailed walkthrough, see:"
echo "  ${DEMO_DIR}/DEMO_WALKTHROUGH_STEP_BY_STEP.md"
echo ""
echo "For presentation, see:"
echo "  ${DEMO_DIR}/DEMO_POWERPOINT_PRESENTATION.md"
echo ""

