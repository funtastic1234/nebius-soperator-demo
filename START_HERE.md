# 🚀 START HERE - Complete Solution Deployment

Welcome! This guide will walk you through deploying and executing the complete Nebius Soperator demo solution.

## 📋 What You Have

✅ **Complete Terraform Configuration**
- 2 nodes × 8 H100s = 16 GPUs total
- fabric-6 configured
- public_o11y_enabled = false
- Separate filesystems for training and inference

✅ **Training Scripts**
- Distributed training job
- Fine-tuning example

✅ **Inference Scripts**
- Trained model inference
- Original model inference

✅ **Comparison & Monitoring**
- Model comparison script
- GPU utilization monitoring

## 🎯 Quick Start (3 Steps)

### Step 1: Get Nebius Credentials

**🎯 EASIEST: Run the interactive script:**
```bash
cd /Users/admin/Desktop/nebius-assignment
./get-credentials.sh
```

This will:
- Guide you to find your Tenant ID
- Help authenticate with Nebius
- Get your IAM token
- Save everything for later use

**OR manually:**

1. **Access Nebius Console:**
   - Go to: https://console.nebius.com
   - Or use your invitation link
   - Log in

2. **Find Tenant ID:**
   - Look at URL: `https://console.nebius.com/tenant-XXXXX/...`
   - Or: Profile icon → Tenant/Organization info

3. **Get IAM Token:**
   ```bash
   # Install Nebius CLI if needed
   nebius iam token create  # Opens browser for auth
   export NEBIUS_TENANT_ID="tenant-<your-tenant-id>"
   export NEBIUS_PROJECT_ID="project-e00pr6smpr00520mtjnf6q"
   export NEBIUS_IAM_TOKEN=$(nebius iam get-access-token)
   ```

**📖 Detailed guide:** See [ACCESS_SANDBOX_GUIDE.md](./ACCESS_SANDBOX_GUIDE.md)

### Step 2: Deploy Cluster

**Option A: Automated (Recommended)**
```bash
cd /Users/admin/Desktop/nebius-assignment
./deploy-full-solution.sh
```

**Option B: Manual**
```bash
cd soperator/installations/demo
source .envrc
terraform init
terraform apply  # Takes ~40 minutes
```

### Step 3: Execute Workflows

After deployment:

1. **Connect to cluster:**
   ```bash
   ssh root@$SLURM_IP -i ~/.ssh/id_ed25519
   ```

2. **Upload scripts:**
   ```bash
   # On local machine
   tar -czf /tmp/demo-scripts.tar.gz \
     soperator/installations/demo/{training,inference,comparison,monitoring}
   scp -i ~/.ssh/id_ed25519 /tmp/demo-scripts.tar.gz root@$SLURM_IP:/opt/
   
   # On cluster
   cd /opt && tar -xzf demo-scripts.tar.gz
   mv soperator/installations/demo /opt/demo
   ```

3. **Run workflows:**
   ```bash
   # On cluster
   /opt/demo/execute-workflows.sh
   ```

## 📚 Detailed Guides

- **[COMPLETE_DEPLOYMENT_GUIDE.md](./COMPLETE_DEPLOYMENT_GUIDE.md)** - Full step-by-step guide
- **[demo-workflows.md](./demo-workflows.md)** - Workflow execution details
- **[QUICK_REFERENCE.md](./QUICK_REFERENCE.md)** - Quick command reference

## 🔧 Configuration Files

- **terraform.tfvars** - Main configuration (already configured with your SSH key)
- **.envrc** - Environment setup (auto-configures service accounts, VPC, etc.)

## ✅ Requirements Checklist

- [x] 16x H100s (2 nodes × 8 GPUs)
- [x] fabric-6 for GPU cluster
- [x] public_o11y_enabled = false
- [x] Separate filesystems for training/inference
- [x] Distributed training scripts
- [x] Inference scripts (trained & original)
- [x] Model comparison script
- [x] GPU utilization monitoring

## 🆘 Need Help?

1. **Deployment issues?** See [COMPLETE_DEPLOYMENT_GUIDE.md](./COMPLETE_DEPLOYMENT_GUIDE.md)
2. **Workflow issues?** See [demo-workflows.md](./demo-workflows.md)
3. **Quick commands?** See [QUICK_REFERENCE.md](./QUICK_REFERENCE.md)

## 🎬 Let's Start!

Run the deployment script and follow the prompts:

```bash
./deploy-full-solution.sh
```

Or follow the manual steps in [COMPLETE_DEPLOYMENT_GUIDE.md](./COMPLETE_DEPLOYMENT_GUIDE.md)

---

**Remember:** Keep the environment running for demo day! 🎉

