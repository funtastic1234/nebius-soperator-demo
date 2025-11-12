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

