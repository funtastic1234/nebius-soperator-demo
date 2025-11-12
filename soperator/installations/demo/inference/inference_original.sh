#!/bin/bash
#SBATCH --job-name=inference-original
#SBATCH --output=/opt/demo/inference/inference-original-%j.out
#SBATCH --error=/opt/demo/inference/inference-original-%j.err
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=8
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=2G
#SBATCH --gres=gpu:8
#SBATCH --time=02:00:00
#SBATCH --partition=main

set -e

echo "Starting inference on original (untrained) model"
echo "Job ID: $SLURM_JOB_ID"
echo "Nodes: $SLURM_JOB_NODELIST"

# Set up environment
export NCCL_DEBUG=INFO
export NCCL_SOCKET_IFNAME=eth0

# Directories
INFERENCE_DIR=/mnt/inference
ORIGINAL_MODEL_DIR=${INFERENCE_DIR}/original
RESULTS_DIR=${INFERENCE_DIR}/results/original
TEST_DATA_DIR=${INFERENCE_DIR}/test_data

mkdir -p ${RESULTS_DIR} ${ORIGINAL_MODEL_DIR} ${TEST_DATA_DIR}

# Run inference using the original (untrained) model
srun python3 << 'PYTHON_SCRIPT'
import torch
import torch.distributed as dist
import json
import os
from datetime import datetime

def setup():
    dist.init_process_group("nccl")
    rank = int(os.environ["RANK"])
    local_rank = int(os.environ["LOCAL_RANK"])
    torch.cuda.set_device(local_rank)
    return rank, local_rank

if __name__ == "__main__":
    rank, local_rank = setup()
    
    original_model_path = "/mnt/inference/original/original_model.pt"
    results_path = "/mnt/inference/results/original"
    
    if rank == 0:
        print(f"Loading original model from {original_model_path}")
    
    # Load original model (untrained/pretrained)
    # This should be the same architecture but without fine-tuning
    if os.path.exists(original_model_path):
        checkpoint = torch.load(original_model_path, map_location=f"cuda:{local_rank}")
        # Load your model architecture and state dict
        # model = YourModel()
        # model.load_state_dict(checkpoint['model_state_dict'])
        # model = model.cuda(local_rank)
        print(f"Original model loaded on rank {rank}")
    else:
        print(f"Warning: Original model not found at {original_model_path}")
        print("Using dummy inference for demonstration")
    
    # Run inference on the same test data
    test_samples = 100
    results = []
    
    for i in range(test_samples):
        # Dummy inference (replace with actual inference)
        input_data = torch.randn(1, 1000).cuda(local_rank)
        # output = model(input_data)
        output = torch.randn(1, 10).cuda(local_rank)  # Placeholder
        
        result = {
            "sample_id": i,
            "rank": rank,
            "output": output.cpu().tolist(),
            "timestamp": datetime.now().isoformat()
        }
        results.append(result)
    
    # Save results
    if rank == 0:
        output_file = f"{results_path}/inference_results.json"
        with open(output_file, 'w') as f:
            json.dump(results, f, indent=2)
        print(f"Results saved to {output_file}")
        print(f"Processed {test_samples} samples")
    
    dist.destroy_process_group()
PYTHON_SCRIPT

echo "Inference on original model completed"
echo "Results saved to: ${RESULTS_DIR}/inference_results.json"

