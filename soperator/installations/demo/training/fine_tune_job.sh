#!/bin/bash
#SBATCH --job-name=bert-finetuning
#SBATCH --output=/opt/demo/training/finetune-%j.out
#SBATCH --error=/opt/demo/training/finetune-%j.err
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=8
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=4G
#SBATCH --gres=gpu:8
#SBATCH --time=06:00:00
#SBATCH --partition=main

set -e

echo "Starting BERT fine-tuning job"
echo "Job ID: $SLURM_JOB_ID"
echo "Nodes: $SLURM_JOB_NODELIST"
echo "GPUs per node: 8"
echo "Total GPUs: 16"

# Set up environment
export NCCL_DEBUG=INFO
export NCCL_SOCKET_IFNAME=eth0
export TRANSFORMERS_OFFLINE=0
export HF_DATASETS_OFFLINE=0

# Training directories
TRAINING_DIR=/mnt/training
DATA_DIR=${TRAINING_DIR}/data
MODEL_DIR=${TRAINING_DIR}/models

mkdir -p ${DATA_DIR} ${MODEL_DIR}

# Example: Fine-tune BERT using Hugging Face Transformers
# This uses a container with PyTorch and Transformers pre-installed

srun --container-image=cr.eu-north1.nebius.cloud#slurm-mlperf-training/pytorch:latest \
     --container-writable \
     --container-mounts=/mnt/training:/mnt/training \
     python3 << 'PYTHON_SCRIPT'
import torch
import torch.distributed as dist
from torch.nn.parallel import DistributedDataParallel as DDP
from transformers import BertForSequenceClassification, BertTokenizer, Trainer, TrainingArguments
from datasets import load_dataset
import os

def setup():
    dist.init_process_group("nccl")
    rank = int(os.environ["RANK"])
    local_rank = int(os.environ["LOCAL_RANK"])
    torch.cuda.set_device(local_rank)
    return rank, local_rank

if __name__ == "__main__":
    rank, local_rank = setup()
    
    if rank == 0:
        print("Loading BERT model and tokenizer...")
    
    # Load pre-trained BERT model
    model_name = "bert-base-uncased"
    model = BertForSequenceClassification.from_pretrained(model_name, num_labels=2)
    tokenizer = BertTokenizer.from_pretrained(model_name)
    
    model = model.cuda(local_rank)
    model = DDP(model, device_ids=[local_rank])
    
    # Load dataset (example: IMDB for sentiment classification)
    if rank == 0:
        print("Loading dataset...")
    
    # For demo purposes, use a small dataset
    # In production, use your actual dataset
    dataset = load_dataset("imdb", split="train[:1000]")
    
    def tokenize_function(examples):
        return tokenizer(examples["text"], padding="max_length", truncation=True, max_length=512)
    
    tokenized_dataset = dataset.map(tokenize_function, batched=True)
    
    # Training arguments
    training_args = TrainingArguments(
        output_dir="/mnt/training/models/bert-finetuned",
        num_train_epochs=3,
        per_device_train_batch_size=8,
        per_device_eval_batch_size=8,
        learning_rate=2e-5,
        weight_decay=0.01,
        logging_dir="/mnt/training/logs",
        logging_steps=10,
        save_strategy="epoch",
        save_total_limit=2,
        load_best_model_at_end=True,
        metric_for_best_model="accuracy",
        greater_is_better=True,
        ddp_find_unused_parameters=False,
    )
    
    # Trainer
    trainer = Trainer(
        model=model.module,
        args=training_args,
        train_dataset=tokenized_dataset,
        tokenizer=tokenizer,
    )
    
    if rank == 0:
        print("Starting training...")
    
    trainer.train()
    
    if rank == 0:
        print("Training completed!")
        print("Model saved to: /mnt/training/models/bert-finetuned")
    
    dist.destroy_process_group()
PYTHON_SCRIPT

echo "Fine-tuning job completed"
echo "Model saved to: ${MODEL_DIR}/bert-finetuned"

