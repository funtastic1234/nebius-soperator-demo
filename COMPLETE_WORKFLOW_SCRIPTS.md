# Complete Workflow Scripts - Training, Inference, and Comparison

This document contains enhanced scripts that ensure both original and fine-tuned models are available for comparison.

## Enhanced Training Script (Saves Original Model First)

### `/opt/demo/training/train_with_original_save.sh`

```bash
#!/bin/bash
#SBATCH --job-name=training-with-original
#SBATCH --output=/opt/demo/training/training-%j.out
#SBATCH --error=/opt/demo/training/training-%j.err
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=8
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=4G
#SBATCH --gres=gpu:8
#SBATCH --time=06:00:00
#SBATCH --partition=main

set -e

echo "=========================================="
echo "Distributed Training with Original Model Preservation"
echo "=========================================="
echo "Job ID: $SLURM_JOB_ID"
echo "Nodes: $SLURM_JOB_NODELIST"
echo "GPUs per node: 8"
echo "Total GPUs: 16"
echo ""

# Directories
TRAINING_DIR=/mnt/training
INFERENCE_DIR=/mnt/inference
DATA_DIR=${TRAINING_DIR}/data
CHECKPOINT_DIR=${TRAINING_DIR}/checkpoints
MODEL_DIR=${TRAINING_DIR}/models
ORIGINAL_MODEL_DIR=${INFERENCE_DIR}/original

mkdir -p ${DATA_DIR} ${CHECKPOINT_DIR} ${MODEL_DIR} ${ORIGINAL_MODEL_DIR}

# Environment setup
export NCCL_DEBUG=INFO
export NCCL_SOCKET_IFNAME=eth0
export CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7

# Step 1: Save original model before training
echo "Step 1: Saving original (pretrained) model..."
srun --ntasks=1 --nodes=1 python3 << 'ORIGINAL_SAVE'
import torch
import os

original_model_path = "/mnt/inference/original/original_model.pt"
os.makedirs(os.path.dirname(original_model_path), exist_ok=True)

# Load pretrained model (example - adjust for your model)
# This should be the model BEFORE fine-tuning
# model = YourModel()
# model.load_state_dict(torch.load("pretrained_model.pt"))

# For demonstration, create a dummy original model
dummy_model = {
    'model_state_dict': {},  # Replace with actual model state
    'epoch': 0,
    'model_type': 'original_pretrained',
    'timestamp': '2025-01-01T00:00:00'
}

torch.save(dummy_model, original_model_path)
print(f"Original model saved to {original_model_path}")
ORIGINAL_SAVE

# Step 2: Run distributed training
echo ""
echo "Step 2: Starting distributed training..."
srun python3 << 'TRAINING_SCRIPT'
import torch
import torch.distributed as dist
import torch.nn as nn
from torch.nn.parallel import DistributedDataParallel as DDP
import os
from datetime import datetime

def setup():
    dist.init_process_group("nccl")
    rank = int(os.environ["RANK"])
    local_rank = int(os.environ["LOCAL_RANK"])
    torch.cuda.set_device(local_rank)
    return rank, local_rank

def cleanup():
    dist.destroy_process_group()

if __name__ == "__main__":
    rank, local_rank = setup()
    
    if rank == 0:
        print(f"Training started at {datetime.now()}")
        print("Using all 16 GPUs for distributed training")
    
    # Training configuration
    num_epochs = 10
    batch_size = 32
    
    # Model setup (example)
    # model = YourModel()
    # model = model.cuda(local_rank)
    # model = DDP(model, device_ids=[local_rank])
    
    # Training loop
    for epoch in range(num_epochs):
        if rank == 0:
            print(f"Epoch {epoch+1}/{num_epochs}")
        
        # Training step (placeholder)
        # for batch in dataloader:
        #     loss = train_step(model, batch)
        #     optimizer.step()
        
        # Save checkpoint
        if rank == 0 and (epoch + 1) % 5 == 0:
            checkpoint = {
                'epoch': epoch,
                'model_state_dict': {},  # model.state_dict(),
                'optimizer_state_dict': {},  # optimizer.state_dict(),
            }
            checkpoint_path = f"/mnt/training/checkpoints/checkpoint_epoch_{epoch+1}.pt"
            torch.save(checkpoint, checkpoint_path)
            print(f"Checkpoint saved: {checkpoint_path}")
    
    # Save final model
    if rank == 0:
        final_model = {
            'model_state_dict': {},  # model.state_dict(),
            'epoch': num_epochs,
            'model_type': 'fine_tuned',
            'timestamp': datetime.now().isoformat()
        }
        model_path = "/mnt/training/models/trained_model.pt"
        torch.save(final_model, model_path)
        print(f"Final trained model saved to {model_path}")
        print(f"Training completed at {datetime.now()}")
    
    cleanup()
TRAINING_SCRIPT

echo ""
echo "=========================================="
echo "Training completed!"
echo "Original model: ${ORIGINAL_MODEL_DIR}/original_model.pt"
echo "Trained model: ${MODEL_DIR}/trained_model.pt"
echo "=========================================="
```

## Enhanced Comparison Workflow

### `/opt/demo/comparison/run_full_comparison.sh`

```bash
#!/bin/bash
# Complete comparison workflow that ensures both models are available

set -e

COMPARISON_DIR=/opt/demo/comparison
TRAINING_DIR=/mnt/training
INFERENCE_DIR=/mnt/inference

echo "=========================================="
echo "Complete Model Comparison Workflow"
echo "=========================================="

# Step 1: Verify both models exist
echo "Step 1: Verifying models..."
ORIGINAL_MODEL="${INFERENCE_DIR}/original/original_model.pt"
TRAINED_MODEL="${TRAINING_DIR}/models/trained_model.pt"

if [ ! -f "$ORIGINAL_MODEL" ]; then
    echo "ERROR: Original model not found at $ORIGINAL_MODEL"
    echo "Please run training script first to save original model"
    exit 1
fi

if [ ! -f "$TRAINED_MODEL" ]; then
    echo "ERROR: Trained model not found at $TRAINED_MODEL"
    echo "Please run training script first"
    exit 1
fi

echo "✓ Original model found: $ORIGINAL_MODEL"
echo "✓ Trained model found: $TRAINED_MODEL"

# Step 2: Run inference on original model
echo ""
echo "Step 2: Running inference on original model..."
cd /opt/demo/inference
ORIGINAL_JOB_ID=$(sbatch inference_original.sh | awk '{print $4}')
echo "Original inference job submitted: $ORIGINAL_JOB_ID"

# Step 3: Run inference on trained model
echo ""
echo "Step 3: Running inference on trained model..."
TRAINED_JOB_ID=$(sbatch inference_trained.sh | awk '{print $4}')
echo "Trained inference job submitted: $TRAINED_JOB_ID"

# Step 4: Wait for both jobs to complete
echo ""
echo "Step 4: Waiting for inference jobs to complete..."
echo "Monitor with: squeue -j $ORIGINAL_JOB_ID,$TRAINED_JOB_ID"

# Wait for jobs
while squeue -j $ORIGINAL_JOB_ID 2>/dev/null | grep -q $ORIGINAL_JOB_ID; do
    sleep 10
done

while squeue -j $TRAINED_JOB_ID 2>/dev/null | grep -q $TRAINED_JOB_ID; do
    sleep 10
done

echo "✓ Both inference jobs completed"

# Step 5: Run comparison
echo ""
echo "Step 5: Running model comparison..."
cd $COMPARISON_DIR

python3 compare_models.py \
    --trained-results ${INFERENCE_DIR}/results/trained/inference_results.json \
    --original-results ${INFERENCE_DIR}/results/original/inference_results.json \
    --output ${INFERENCE_DIR}/results/comparison_report.json

echo ""
echo "=========================================="
echo "Comparison complete!"
echo "Report: ${INFERENCE_DIR}/results/comparison_report.json"
echo "=========================================="
```

## GPU Utilization Monitoring Script

### `/opt/demo/monitoring/check_gpu_util.sh`

```bash
#!/bin/bash
# Monitor GPU utilization across all nodes

echo "=========================================="
echo "GPU Utilization Monitor"
echo "=========================================="
echo ""

# Get all GPU nodes
GPU_NODES=$(sinfo -N -o "%N" -p gpu | grep -v NODELIST | head -2)

for node in $GPU_NODES; do
    echo "Node: $node"
    echo "----------------------------------------"
    srun -w $node --gres=gpu:1 nvidia-smi --query-gpu=index,name,utilization.gpu,utilization.memory,memory.used,memory.total --format=csv,noheader,nounits
    echo ""
done

# Calculate average utilization
echo "Average GPU Utilization:"
srun --gres=gpu:1 nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | awk '{sum+=$1; count++} END {if(count>0) printf "%.1f%%\n", sum/count; else print "N/A"}'
```

