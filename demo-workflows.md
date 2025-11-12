# Demo Workflows - Training, Inference, and Comparison

This guide walks through running distributed training/fine-tuning, inference, and model comparison on the Nebius Soperator cluster.

## Prerequisites

1. Cluster is deployed and accessible via SSH
2. You have SSH access to the login node
3. Required datasets/models are available (or will be downloaded)

## Directory Structure

The demo uses the following directory structure:
- `/mnt/training` - Training data, checkpoints, and trained models
- `/mnt/inference` - Inference scripts and results
- `/opt/demo` - Demo scripts and utilities

## Step 1: Setup Demo Environment

SSH into the cluster and run:

```bash
# Create demo directories
mkdir -p /opt/demo/{training,inference,comparison,monitoring}
mkdir -p /mnt/training/{data,checkpoints,models}
mkdir -p /mnt/inference/{models,results,original}

# Upload demo scripts (if not already present)
# These will be created in the next steps
```

## Step 2: Distributed Training/Fine-Tuning

### Option A: Using PyTorch Distributed Training

Run the training job:

```bash
cd /opt/demo/training
sbatch train_job.sh
```

Monitor the job:
```bash
squeue
tail -f training-*.out
```

### Option B: Using Hugging Face Transformers

For fine-tuning a transformer model:

```bash
cd /opt/demo/training
sbatch fine_tune_job.sh
```

### GPU Utilization Check

While training is running, check GPU utilization:
```bash
watch -n 5 /opt/demo/monitoring/check_gpu_util.sh
```

The script should show >80% GPU utilization across all 16 GPUs.

## Step 3: Run Inference on Trained Model

Once training completes, run inference:

```bash
cd /opt/demo/inference
sbatch inference_trained.sh
```

This will:
- Load the trained model from `/mnt/training/models/`
- Run inference on test data
- Save results to `/mnt/inference/results/trained/`

## Step 4: Run Inference on Original Model

Run inference on the original (untrained) model:

```bash
cd /opt/demo/inference
sbatch inference_original.sh
```

This will:
- Load the original model
- Run inference on the same test data
- Save results to `/mnt/inference/results/original/`

## Step 5: Compare Results

Compare the results of both models:

```bash
cd /opt/demo/comparison
python compare_models.py \
  --trained_results /mnt/inference/results/trained \
  --original_results /mnt/inference/results/original \
  --output /mnt/inference/results/comparison_report.json
```

## Step 6: Monitor GPU Utilization

Throughout all steps, monitor GPU utilization:

```bash
/opt/demo/monitoring/monitor_gpus.sh
```

This will generate a report showing GPU utilization across all nodes.

## Example: Fine-tuning BERT for Text Classification

A complete example workflow is provided in `/opt/demo/examples/bert_finetuning/`.

## Troubleshooting

1. **Low GPU Utilization**: Check if jobs are using all available GPUs
   ```bash
   scontrol show job <job_id>
   ```

2. **Storage Issues**: Ensure separate filesystems are mounted correctly
   ```bash
   df -h | grep -E "(training|inference)"
   ```

3. **Model Loading Errors**: Verify model paths and formats
   ```bash
   ls -lh /mnt/training/models/
   ```

