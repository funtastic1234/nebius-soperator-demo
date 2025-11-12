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
from datetime import datetime

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
    'timestamp': datetime.now().isoformat(),
    'description': 'Original pretrained model before fine-tuning'
}

torch.save(dummy_model, original_model_path)
print(f"✓ Original model saved to {original_model_path}")
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
            print(f"✓ Checkpoint saved: {checkpoint_path}")
    
    # Save final model
    if rank == 0:
        final_model = {
            'model_state_dict': {},  # model.state_dict(),
            'epoch': num_epochs,
            'model_type': 'fine_tuned',
            'timestamp': datetime.now().isoformat(),
            'description': 'Fine-tuned model after distributed training'
        }
        model_path = "/mnt/training/models/trained_model.pt"
        torch.save(final_model, model_path)
        print(f"✓ Final trained model saved to {model_path}")
        print(f"Training completed at {datetime.now()}")
    
    cleanup()
TRAINING_SCRIPT

echo ""
echo "=========================================="
echo "Training completed!"
echo "Original model: ${ORIGINAL_MODEL_DIR}/original_model.pt"
echo "Trained model: ${MODEL_DIR}/trained_model.pt"
echo "=========================================="

