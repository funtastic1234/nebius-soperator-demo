#!/bin/bash
#SBATCH --job-name=distributed-training
#SBATCH --output=/opt/demo/training/training-%j.out
#SBATCH --error=/opt/demo/training/training-%j.err
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=8
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=4G
#SBATCH --gres=gpu:8
#SBATCH --time=04:00:00
#SBATCH --partition=main

set -e

echo "Starting distributed training job"
echo "Job ID: $SLURM_JOB_ID"
echo "Nodes: $SLURM_JOB_NODELIST"
echo "GPUs per node: 8"
echo "Total GPUs: 16"

# Set up environment
export NCCL_DEBUG=INFO
export NCCL_SOCKET_IFNAME=eth0
export CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7

# Training directories
TRAINING_DIR=/mnt/training
DATA_DIR=${TRAINING_DIR}/data
CHECKPOINT_DIR=${TRAINING_DIR}/checkpoints
MODEL_DIR=${TRAINING_DIR}/models

# Create directories
mkdir -p ${DATA_DIR} ${CHECKPOINT_DIR} ${MODEL_DIR}

# Example: PyTorch distributed training
# This is a template - customize for your specific model

srun python3 << 'PYTHON_SCRIPT'
import torch
import torch.distributed as dist
import torch.nn as nn
from torch.nn.parallel import DistributedDataParallel as DDP
import os

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
    
    print(f"Rank {rank}, Local Rank {local_rank}, GPU {local_rank}")
    
    # Example model (replace with your actual model)
    model = nn.Sequential(
        nn.Linear(1000, 512),
        nn.ReLU(),
        nn.Linear(512, 10)
    ).cuda(local_rank)
    
    model = DDP(model, device_ids=[local_rank])
    
    # Training loop (simplified example)
    optimizer = torch.optim.Adam(model.parameters(), lr=0.001)
    criterion = nn.CrossEntropyLoss()
    
    # Dummy training data
    for epoch in range(10):
        inputs = torch.randn(32, 1000).cuda(local_rank)
        targets = torch.randint(0, 10, (32,)).cuda(local_rank)
        
        optimizer.zero_grad()
        outputs = model(inputs)
        loss = criterion(outputs, targets)
        loss.backward()
        optimizer.step()
        
        if rank == 0:
            print(f"Epoch {epoch}, Loss: {loss.item()}")
    
    # Save model checkpoint
    if rank == 0:
        checkpoint = {
            'model_state_dict': model.module.state_dict(),
            'optimizer_state_dict': optimizer.state_dict(),
            'epoch': epoch,
        }
        torch.save(checkpoint, '/mnt/training/models/trained_model.pt')
        print("Model saved to /mnt/training/models/trained_model.pt")
    
    cleanup()
PYTHON_SCRIPT

echo "Training job completed"
echo "Model saved to: ${MODEL_DIR}/trained_model.pt"

