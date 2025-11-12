# Complete Demo Walkthrough - Step by Step

This is a detailed, step-by-step walkthrough for demonstrating the Nebius Soperator solution.

---

## Pre-Demo Setup (Before Audience Arrives)

### 1. Verify Infrastructure Status
```bash
cd /Users/admin/Desktop/nebius-assignment/soperator/installations/demo
export PATH="/Users/admin/.config/tfenv/versions/1.8.5:$PATH"
source ~/.nebius_encrypted_credentials.sh
source .envrc

# Check deployment status
terraform state list | grep -E "cluster|node_group"
kubectl get nodes
```

### 2. Prepare Demo Materials
- Open presentation (DEMO_POWERPOINT_PRESENTATION.md)
- Have terminal windows ready:
  - Terminal 1: Local machine (Terraform/SSH)
  - Terminal 2: Slurm login node (training/inference)
  - Terminal 3: Monitoring (GPU utilization)

### 3. Pre-load Data (Optional)
If you have a dataset ready, upload it before the demo:
```bash
# After SSH access is available
scp -r /path/to/dataset root@<login-ip>:/mnt/training/data/
```

---

## Demo Flow - Step by Step

### PART 1: Introduction & Architecture (5 minutes)

#### Step 1.1: Welcome & Overview
**What to say:**
> "Today I'll demonstrate Nebius Soperator, a solution that combines Slurm workload management with Kubernetes orchestration for distributed ML training. We'll deploy a 16-GPU cluster, run distributed training, and compare model performance."

**Action:**
- Show Slide 1 (Title)
- Show Slide 2 (Agenda)

#### Step 1.2: Architecture Overview
**What to say:**
> "Let me show you the architecture we've deployed. We have a Kubernetes cluster with Slurm integrated, 2 GPU worker nodes with 8 H100 GPUs each, connected via high-speed Infiniband fabric-6."

**Action:**
- Show Slide 4 (Architecture)
- Run command to show cluster:
```bash
kubectl get nodes -o wide
kubectl get pods -n soperator
```

**Expected Output:**
```
NAME                    STATUS   ROLES    GPU
worker-0-0-xxx          Ready    <none>   8x H100
worker-0-0-yyy          Ready    <none>   8x H100
```

---

### PART 2: Infrastructure Walkthrough (10 minutes)

#### Step 2.1: Show Terraform Configuration
**What to say:**
> "The entire infrastructure is defined as code using Terraform. Let me show you the key configuration."

**Action:**
- Show Slide 5 (Infrastructure Setup)
- Open terraform.tfvars:
```bash
cat soperator/installations/demo/terraform.tfvars | grep -A 10 "slurm_nodeset_workers"
```

**Highlight:**
- 2 nodes, 8 GPUs each = 16 total
- Fabric-6 Infiniband
- Separate filesystems

#### Step 2.2: Show Deployment Status
**What to say:**
> "The infrastructure is already deployed. Let me verify the current state."

**Action:**
```bash
terraform state list | head -20
terraform output 2>/dev/null || echo "Getting cluster info..."
```

**Show:**
- Kubernetes cluster ID
- GPU cluster ID
- Node group IDs

#### Step 2.3: Access Slurm Cluster
**What to say:**
> "Now let's access the Slurm login node where we'll submit our training jobs."

**Action:**
```bash
# Get login IP
cat ./login.sh | grep ssh || terraform output slurm_login_ip

# SSH into cluster (Terminal 2)
ssh root@<login-ip> -i ~/.ssh/<your-key>
```

**Once connected:**
```bash
# Verify Slurm is running
sinfo
squeue
```

**Expected Output:**
```
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
main*        up   infinite      2   idle worker-0-0-[0-1]
```

---

### PART 3: Distributed Training (15 minutes)

#### Step 3.1: Prepare Training Environment
**What to say:**
> "Before we start training, let's set up our environment and ensure we have the training scripts ready."

**Action (on login node):**
```bash
# Check directories
ls -la /mnt/training/
ls -la /mnt/inference/
ls -la /opt/demo/

# If scripts not uploaded, upload them:
# (From local machine, Terminal 1)
# scp -r soperator/installations/demo/training root@<login-ip>:/opt/demo/
# scp -r soperator/installations/demo/inference root@<login-ip>:/opt/demo/
# scp -r soperator/installations/demo/comparison root@<login-ip>:/opt/demo/
```

#### Step 3.2: Explain Training Workflow
**What to say:**
> "Our training workflow does two important things: First, it saves the original pretrained model so we can compare it later. Then it runs distributed training across all 16 GPUs."

**Action:**
- Show Slide 7 (Training Workflow)
- Show Slide 8 (Training Job Details)
- Open training script:
```bash
cat /opt/demo/training/train_with_original_save.sh | head -30
```

**Highlight:**
- Original model saved first
- Distributed training with DDP
- Checkpoint saving
- Final model saved

#### Step 3.3: Submit Training Job
**What to say:**
> "Now let's submit the training job. This will use all 16 GPUs across 2 nodes."

**Action:**
```bash
cd /opt/demo/training
sbatch train_with_original_save.sh
```

**Expected Output:**
```
Submitted batch job 12345
```

**Show job details:**
```bash
squeue -j 12345
scontrol show job 12345
```

#### Step 3.4: Monitor Training Progress
**What to say:**
> "While the training runs, let's monitor GPU utilization to ensure we're efficiently using all GPUs."

**Action (Terminal 3 - Monitoring):**
```bash
# Real-time GPU monitoring
watch -n 5 'srun --gres=gpu:1 nvidia-smi --query-gpu=index,utilization.gpu,memory.used --format=csv'
```

**Or use custom script:**
```bash
watch -n 5 /opt/demo/monitoring/check_gpu_util.sh
```

**Show Slide 9 (GPU Utilization)**

**Expected Output:**
```
GPU Utilization: 82-85% average
Memory: High utilization
All 16 GPUs active
```

**What to say:**
> "As you can see, we're achieving over 80% GPU utilization across all 16 GPUs, which is excellent for distributed training."

#### Step 3.5: Check Training Output
**What to say:**
> "Let's check the training output to see the progress."

**Action:**
```bash
# On login node
tail -f /opt/demo/training/training-12345.out
```

**Show:**
- Epoch progress
- Loss values
- Checkpoint saves
- Completion message

**Note:** If training takes too long, you can show a previous run's output or explain what would happen.

---

### PART 4: Inference & Comparison (10 minutes)

#### Step 4.1: Verify Models Are Saved
**What to say:**
> "After training completes, we have both models saved: the original pretrained model and the fine-tuned model."

**Action:**
```bash
# Check models
ls -lh /mnt/inference/original/
ls -lh /mnt/training/models/
ls -lh /mnt/training/checkpoints/
```

**Show:**
- Original model: `/mnt/inference/original/original_model.pt`
- Trained model: `/mnt/training/models/trained_model.pt`
- Checkpoints: Multiple checkpoint files

#### Step 4.2: Run Inference on Original Model
**What to say:**
> "Now let's run inference on the original model to establish a baseline."

**Action:**
- Show Slide 10 (Inference Workflow)
```bash
cd /opt/demo/inference
sbatch inference_original.sh
```

**Expected Output:**
```
Submitted batch job 12346
```

**Monitor:**
```bash
squeue -j 12346
tail -f /opt/demo/inference/inference-original-12346.out
```

#### Step 4.3: Run Inference on Trained Model
**What to say:**
> "Now let's run inference on the fine-tuned model using the same test dataset."

**Action:**
```bash
sbatch inference_trained.sh
```

**Expected Output:**
```
Submitted batch job 12347
```

**Monitor:**
```bash
squeue -j 12347
tail -f /opt/demo/inference/inference-trained-12347.out
```

#### Step 4.4: Wait for Both Jobs (or Show Previous Results)
**What to say:**
> "Both inference jobs are running. While they complete, let me show you what the results will look like."

**Action:**
- Show Slide 11 (Model Comparison)
- If previous results exist:
```bash
ls -lh /mnt/inference/results/original/
ls -lh /mnt/inference/results/trained/
```

#### Step 4.5: Run Comparison
**What to say:**
> "Once both inference jobs complete, we'll compare the results to see the improvement from fine-tuning."

**Action:**
```bash
# Wait for jobs to complete
while squeue -j 12346,12347 2>/dev/null | grep -q -E "12346|12347"; do
    echo "Waiting for inference jobs..."
    sleep 10
done

# Run comparison
cd /opt/demo/comparison
python3 compare_models.py \
    --trained-results /mnt/inference/results/trained/inference_results.json \
    --original-results /mnt/inference/results/original/inference_results.json \
    --output /mnt/inference/results/comparison_report.json
```

**Show Output:**
```bash
cat /mnt/inference/results/comparison_report.json | python3 -m json.tool
```

**Show Slide 12 (Comparison Results)**

---

### PART 5: Results & Takeaways (5 minutes)

#### Step 5.1: Show Performance Metrics
**What to say:**
> "Let's review the key performance metrics from our demonstration."

**Action:**
- Show Slide 13 (Key Features)
- Show Slide 14 (Technical Highlights)
- Show Slide 15 (Performance Metrics)

**Display metrics:**
```bash
# GPU utilization summary
/opt/demo/monitoring/check_gpu_util.sh

# Training time
grep "Training completed" /opt/demo/training/training-*.out

# Model sizes
du -sh /mnt/inference/original/
du -sh /mnt/training/models/
```

#### Step 5.2: Show Comparison Results
**What to say:**
> "The comparison shows clear improvement from fine-tuning. Let me highlight the key differences."

**Action:**
- Show Slide 12 (Comparison Results)
- Display comparison report:
```bash
cat /mnt/inference/results/comparison_report.json
```

**Highlight:**
- Improvement percentage
- Mean difference
- Standard deviation changes

#### Step 5.3: Key Takeaways
**What to say:**
> "Let me summarize what we've accomplished and the key takeaways."

**Action:**
- Show Slide 19 (Key Takeaways)
- Show Slide 20 (Q&A)

**Points to emphasize:**
1. ✅ Complete infrastructure deployed with Terraform
2. ✅ Distributed training across 16 GPUs
3. ✅ >80% GPU utilization achieved
4. ✅ Both models preserved for comparison
5. ✅ Quantitative performance improvement demonstrated

---

## Demo Tips & Best Practices

### Before Demo:
1. **Test Everything:**
   - Run through the entire workflow once
   - Verify all scripts work
   - Check that models are saved correctly

2. **Prepare Fallbacks:**
   - Have previous run results ready
   - Screenshots of expected outputs
   - Pre-recorded video (backup)

3. **Time Management:**
   - Training can take hours - use a short demo dataset
   - Or show previous results
   - Focus on the workflow, not waiting for completion

### During Demo:
1. **Explain as You Go:**
   - Don't just run commands silently
   - Explain what each step does
   - Connect to the bigger picture

2. **Handle Errors Gracefully:**
   - If something fails, explain why
   - Show how to troubleshoot
   - Have recovery steps ready

3. **Engage Audience:**
   - Ask if they have questions
   - Pause for clarification
   - Show relevant slides during each step

### After Demo:
1. **Provide Resources:**
   - Share presentation
   - Share code repository
   - Share documentation

2. **Follow Up:**
   - Answer questions
   - Provide additional examples
   - Offer to help with their use cases

---

## Troubleshooting Guide

### Issue: Can't SSH into cluster
**Solution:**
```bash
# Check if login node is ready
kubectl get pods -n soperator | grep login

# Get IP from Terraform
terraform output slurm_login_ip

# Or check login.sh
cat ./login.sh
```

### Issue: Training job fails
**Solution:**
```bash
# Check job status
scontrol show job <job_id>

# Check logs
cat /opt/demo/training/training-<job_id>.err

# Check node status
sinfo -N
```

### Issue: GPU utilization low
**Solution:**
```bash
# Check if all GPUs are allocated
scontrol show job <job_id> | grep -i gpu

# Check node resources
scontrol show node <node_name>

# Verify NCCL setup
export NCCL_DEBUG=INFO
```

### Issue: Models not found
**Solution:**
```bash
# Check filesystem mounts
df -h | grep -E "training|inference"

# Check model directories
ls -la /mnt/training/models/
ls -la /mnt/inference/original/

# Verify training completed
grep "Training completed" /opt/demo/training/training-*.out
```

---

## Quick Reference Commands

### Deployment
```bash
cd soperator/installations/demo
terraform init -reconfigure
terraform apply -auto-approve
```

### Cluster Access
```bash
ssh root@<login-ip> -i ~/.ssh/<key>
```

### Job Management
```bash
sbatch <script.sh>          # Submit job
squeue                       # List jobs
squeue -u $USER             # Your jobs
scancel <job_id>            # Cancel job
scontrol show job <job_id>  # Job details
```

### Monitoring
```bash
sinfo                        # Node status
nvidia-smi                  # GPU status
watch -n 5 nvidia-smi       # Real-time GPU
/opt/demo/monitoring/check_gpu_util.sh
```

### Model Management
```bash
ls /mnt/training/models/           # Trained models
ls /mnt/inference/original/        # Original models
ls /mnt/inference/results/         # Inference results
cat /mnt/inference/results/comparison_report.json
```

---

## Demo Checklist

### Pre-Demo:
- [ ] Infrastructure deployed and verified
- [ ] SSH access to login node working
- [ ] Training scripts uploaded
- [ ] Monitoring tools ready
- [ ] Presentation slides prepared
- [ ] Terminal windows organized
- [ ] Backup results available (if needed)

### During Demo:
- [ ] Show architecture overview
- [ ] Demonstrate Terraform configuration
- [ ] Access Slurm cluster
- [ ] Submit training job
- [ ] Monitor GPU utilization
- [ ] Show training progress
- [ ] Run inference on both models
- [ ] Compare results
- [ ] Show performance metrics
- [ ] Summarize key takeaways

### Post-Demo:
- [ ] Answer questions
- [ ] Share resources
- [ ] Provide follow-up contact
- [ ] Document any issues encountered

---

## Expected Timeline

- **Part 1: Introduction** - 5 minutes
- **Part 2: Infrastructure** - 10 minutes
- **Part 3: Training** - 15 minutes
- **Part 4: Inference & Comparison** - 10 minutes
- **Part 5: Results & Takeaways** - 5 minutes
- **Q&A** - 10-15 minutes

**Total: ~55-60 minutes**

---

## Success Criteria

✅ **Infrastructure:**
- Cluster deployed successfully
- All nodes healthy
- Slurm operational

✅ **Training:**
- Job submitted successfully
- >80% GPU utilization
- Models saved correctly

✅ **Inference:**
- Both models available
- Inference jobs complete
- Results saved

✅ **Comparison:**
- Comparison script runs
- Clear metrics shown
- Improvement demonstrated

✅ **Demo:**
- Smooth presentation
- All steps work
- Audience understands workflow

