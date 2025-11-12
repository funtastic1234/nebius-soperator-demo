#!/usr/bin/env python3
"""
Compare results from trained and original models.
"""

import json
import argparse
import numpy as np
from pathlib import Path
from datetime import datetime


def load_results(results_path):
    """Load inference results from JSON file."""
    with open(results_path, 'r') as f:
        return json.load(f)


def calculate_metrics(results):
    """Calculate various metrics from inference results."""
    # Extract outputs
    outputs = [np.array(r['output']) for r in results]
    
    # Calculate statistics
    mean_output = np.mean([np.mean(o) for o in outputs])
    std_output = np.std([np.std(o) for o in outputs])
    
    # Count samples
    num_samples = len(results)
    
    return {
        'num_samples': num_samples,
        'mean_output': float(mean_output),
        'std_output': float(std_output),
        'min_output': float(np.min([np.min(o) for o in outputs])),
        'max_output': float(np.max([np.max(o) for o in outputs])),
    }


def compare_results(trained_results, original_results):
    """Compare trained and original model results."""
    comparison = {
        'timestamp': datetime.now().isoformat(),
        'trained_model': calculate_metrics(trained_results),
        'original_model': calculate_metrics(original_results),
    }
    
    # Calculate differences
    trained_metrics = comparison['trained_model']
    original_metrics = comparison['original_model']
    
    comparison['differences'] = {
        'mean_diff': trained_metrics['mean_output'] - original_metrics['mean_output'],
        'std_diff': trained_metrics['std_output'] - original_metrics['std_output'],
        'improvement_percent': (
            (trained_metrics['mean_output'] - original_metrics['mean_output']) /
            abs(original_metrics['mean_output']) * 100
            if original_metrics['mean_output'] != 0 else 0
        ),
    }
    
    return comparison


def main():
    parser = argparse.ArgumentParser(description='Compare trained and original model results')
    parser.add_argument('--trained-results', required=True, help='Path to trained model results JSON')
    parser.add_argument('--original-results', required=True, help='Path to original model results JSON')
    parser.add_argument('--output', required=True, help='Output path for comparison report')
    
    args = parser.parse_args()
    
    print("Loading results...")
    trained_results = load_results(args.trained_results)
    original_results = load_results(args.original_results)
    
    print("Comparing models...")
    comparison = compare_results(trained_results, original_results)
    
    # Save comparison report
    output_path = Path(args.output)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    
    with open(output_path, 'w') as f:
        json.dump(comparison, f, indent=2)
    
    # Print summary
    print("\n" + "="*60)
    print("COMPARISON SUMMARY")
    print("="*60)
    print(f"\nTrained Model:")
    print(f"  Samples: {comparison['trained_model']['num_samples']}")
    print(f"  Mean Output: {comparison['trained_model']['mean_output']:.4f}")
    print(f"  Std Output: {comparison['trained_model']['std_output']:.4f}")
    
    print(f"\nOriginal Model:")
    print(f"  Samples: {comparison['original_model']['num_samples']}")
    print(f"  Mean Output: {comparison['original_model']['mean_output']:.4f}")
    print(f"  Std Output: {comparison['original_model']['std_output']:.4f}")
    
    print(f"\nDifferences:")
    print(f"  Mean Difference: {comparison['differences']['mean_diff']:.4f}")
    print(f"  Improvement: {comparison['differences']['improvement_percent']:.2f}%")
    
    print(f"\nFull report saved to: {output_path}")
    print("="*60)


if __name__ == '__main__':
    main()

