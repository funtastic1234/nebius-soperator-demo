# What's Left from the Assignment

## ✅ COMPLETED (Infrastructure Setup)

1. ✅ **Terraform Configuration**
   - Terraform 1.8.5 installed and validated
   - All configuration files properly set up
   - `public_o11y_enabled = false` ✓
   - Separate filesystems for training/inference ✓
   - Fabric-6 configured ✓
   - 16x H100 GPUs (2 nodes × 8 GPUs) ✓

2. ✅ **Infrastructure Resources Created**
   - Kubernetes cluster: `mk8scluster-e00c2tyxc57dkgnek9`
   - GPU cluster with fabric-6: `computegpucluster-e00r88w5mr2w3xw565`
   - Worker node groups (2 nodes with 8 H100s each)
   - Filesystems (jail, training, inference)
   - Storage classes and backups configured

3. ✅ **Prerequisites**
   - Nebius CLI installed and configured
   - yq installed
   - Credentials saved securely

## ⏳ REMAINING TASKS

### 1. Complete Terraform Deployment (CRITICAL - Must do first)
**Status:** Infrastructure is created but Slurm components need to finish deploying

**Action Required:**
```bash
cd /Users/admin/Desktop/nebius-assignment/soperator/installations/demo
export PATH="/Users/admin/.config/tfenv/versions/1.8.5:$PATH"
source ~/.nebius_encrypted_credentials.sh
source .envrc
terraform init -reconfigure
terraform apply -auto-approve
```

**What this does:**
- Deploys Slurm components via Helm/FluxCD
- Sets up Slurm controller, login nodes, and worker nodes
- Configures Slurm job scheduling
- Creates SSH access to login nodes

**Expected time:** 20-40 minutes

---

### 2. Task 1: Distributed Training/Fine-tuning (REQUIRED FOR PASS) ⭐

**Status:** Not started - waiting for Slurm deployment

**Steps:**
1. Get SSH access to login node:
   ```bash
   # After terraform apply completes, get login IP
   terraform output slurm_login_ip
   # Or check login.sh file
   cat ./login.sh
   
   # SSH into cluster
   ssh root@<login-ip> -i ~/.ssh/<your-key>
   ```

2. Upload training scripts:
   ```bash
   # From your local machine
   scp -r soperator/installations/demo/training root@<login-ip>:/opt/demo/
   scp -r soperator/installations/demo/inference root@<login-ip>:/opt/demo/
   ```

3. Run distributed training:
   ```bash
   # On login node
   cd /opt/demo/training
   sbatch train_job.sh  # or fine_tune_job.sh
   
   # Monitor job
   squeue
   tail -f training-*.out
   ```

4. Verify GPU utilization >80%:
   ```bash
   # While training runs
   watch -n 5 nvidia-smi
   # Or use monitoring script
   /opt/demo/monitoring/check_gpu_util.sh
   ```

**Expected time:** 2-6 hours (depending on model/dataset)

---

### 3. Task 2: Inference on Trained Model (BONUS)

**Status:** Not started

**Steps:**
1. After training completes, run inference:
   ```bash
   cd /opt/demo/inference
   sbatch inference_trained.sh
   ```

2. Results saved to `/mnt/inference/results/trained/`

**Expected time:** 30 minutes - 1 hour

---

### 4. Task 3: Compare Models (BONUS)

**Status:** Not started

**Steps:**
1. Run inference on original model:
   ```bash
   cd /opt/demo/inference
   sbatch inference_original.sh
   ```

2. Compare results:
   ```bash
   cd /opt/demo/comparison
   python3 compare_models.py \
     --trained-results /mnt/inference/results/trained/inference_results.json \
     --original-results /mnt/inference/results/original/inference_results.json \
     --output /mnt/inference/results/comparison_report.json
   ```

**Expected time:** 1-2 hours

---

### 5. Task 4: GPU Utilization Monitoring (BONUS)

**Status:** Partially - need to verify during training

**Steps:**
- Monitor during Task 1 (training)
- Document utilization metrics
- Ensure >80% utilization across all 16 GPUs

---

## Priority Order

1. **IMMEDIATE:** Complete Terraform deployment (`terraform apply`)
2. **CRITICAL (Pass):** Task 1 - Run distributed training
3. **BONUS:** Tasks 2-4 (inference, comparison, monitoring)

## Estimated Total Time Remaining

- Terraform deployment: 20-40 minutes
- Training job: 2-6 hours
- Bonus tasks: 2-3 hours
- **Total: 4-10 hours**

## Quick Start Command

```bash
cd /Users/admin/Desktop/nebius-assignment/soperator/installations/demo
export PATH="/Users/admin/.config/tfenv/versions/1.8.5:$PATH"
source ~/.nebius_encrypted_credentials.sh
source .envrc
terraform init -reconfigure && terraform apply -auto-approve
```

