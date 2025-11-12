# Quick Reference Card

## Essential Commands

### Setup
```bash
# Setup Nebius access
./setup-nebius-access.sh
source ~/.nebius_env

# Deploy cluster
cd soperator/installations/demo
terraform init
terraform apply  # Takes ~40 minutes
```

### Connect
```bash
# Get login IP
export SLURM_IP=$(terraform output -raw slurm_login_ip 2>/dev/null || \
  terraform state show module.login_script.terraform_data.lb_service_ip | \
  grep 'input' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)

# SSH
ssh root@$SLURM_IP -i ~/.ssh/<key>
```

### Run Jobs
```bash
# Training
cd /opt/demo/training
sbatch train_job.sh

# Monitor
watch -n 5 /opt/demo/monitoring/check_gpu_util.sh
squeue

# Inference
cd /opt/demo/inference
sbatch inference_trained.sh
sbatch inference_original.sh

# Compare
cd /opt/demo/comparison
python3 compare_models.py \
  --trained-results /mnt/inference/results/trained/inference_results.json \
  --original-results /mnt/inference/results/original/inference_results.json \
  --output /mnt/inference/results/comparison_report.json
```

## Key Configuration Values

| Setting | Value | Location |
|---------|-------|-----------|
| GPU Nodes | 2 | terraform.tfvars:192 |
| GPUs per Node | 8 | terraform.tfvars:192 |
| Total GPUs | 16 | - |
| Fabric | fabric-6 | terraform.tfvars:192 |
| Public O11y | false | terraform.tfvars:300 |
| Region | eu-north1 | terraform.tfvars:47 |

## Directory Structure

```
/mnt/training/          # Training data, models, checkpoints
/mnt/inference/         # Inference scripts, results
/opt/demo/              # Demo scripts
  ├── training/         # Training job scripts
  ├── inference/        # Inference scripts
  ├── comparison/       # Comparison scripts
  └── monitoring/       # GPU monitoring
```

## Monitoring

```bash
# Check GPU utilization
/opt/demo/monitoring/check_gpu_util.sh

# Continuous monitoring
/opt/demo/monitoring/monitor_gpus.sh

# Check job status
squeue
scontrol show job <job_id>

# View logs
tail -f /opt/demo/training/training-*.out
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "Not Enough Resources" | Verify `fabric-6` is set |
| Low GPU utilization | Check job allocation with `scontrol show job` |
| Storage issues | Verify mounts: `df -h \| grep -E "(training\|inference)"` |
| SSH connection fails | Check SSH key in terraform.tfvars |

## Important Notes

- ⚠️ **DO NOT DESTROY** the lab environment
- ✓ Use **fabric-6** for GPU cluster
- ✓ Set **public_o11y_enabled = false**
- ✓ Use **separate filesystems** for training and inference
- ✓ Monitor GPU utilization to ensure **>80%**

