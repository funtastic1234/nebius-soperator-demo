# Nebius Soperator Assignment Status

## Original Requirements

### Core Tasks (Task 1 = Pass):
1.  Run a distributed training/fine-tuning job utilizing Soperator solution
2.  Run inference on the same k8s cluster, serving the trained model
3.  Run the original (untrained) model, and compare results
4.  Utilize more than 80% of the GPUs

### Configuration Requirements:
- Capacity limits: 16xH100s max (2 nodes × 8 GPUs each)
-  Single MK8s cluster
-  Use fabric-6 for gpu_cluster
-  Turn public_o11y_enabled = false in .tfvars
-  Install yq lib
-  Avoid using the same shared filesystem for 2 different jails (separate training/inference mounts)

## Current Status

###  Completed:
1. **Infrastructure Deployment:**
   -  Kubernetes cluster created (mk8scluster-e00c2tyxc57dkgnek9)
   -  GPU cluster created with fabric-6 (computegpucluster-e00r88w5mr2w3xw565)
   -  Worker node groups created (2 nodes, 8 H100s each = 16 GPUs total)
   -  Filesystems configured (jail, training, inference - separate mounts)
   -  Terraform configuration validated (Terraform 1.8.5)
   -  All prerequisites installed (yq, nebius CLI, terraform)

2. **Configuration:**
   -  public_o11y_enabled = false
   -  Separate filesystems for training and inference
   -  Fabric-6 configured for GPU cluster
   -  Credentials saved securely

###  Remaining Tasks:

1. **Complete Terraform Deployment:**
   -  Finish deploying Slurm components via Helm/FluxCD
   -  Verify Slurm cluster is operational
   -  Get SSH access to login nodes

2. **Task 1: Distributed Training/Fine-tuning (REQUIRED FOR PASS):**
   -  SSH into Slurm login node
   -  Prepare training dataset
   -  Create Slurm job script for distributed training
   -  Submit and run training job across 16 GPUs
   -  Monitor GPU utilization (target: >80%)
   -  Save trained model

3. **Task 2: Inference on Trained Model (BONUS):**
   -  Deploy inference service on K8s cluster
   -  Serve the trained model
   -  Test inference endpoint

4. **Task 3: Compare Models (BONUS):**
   -  Run original (untrained) model
   -  Compare results with trained model
   -  Document differences

5. **Task 4: GPU Utilization (BONUS):**
   -  Monitor and verify >80% GPU utilization during training
   -  Document utilization metrics

##  Steps

1. Complete Terraform deployment to finish Slurm setup
2. Access Slurm login node via SSH
3. Run distributed training job
4. Complete bonus tasks (inference, comparison, monitoring)

