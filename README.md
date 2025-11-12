# Nebius Soperator - Distributed ML Training on Kubernetes

Complete solution for deploying and running distributed machine learning training jobs on Nebius Cloud using Soperator (Slurm on Kubernetes).

## 🎯 What This Project Does

This project demonstrates:
- **Distributed Training:** Training AI models across 16x H100 GPUs
- **Model Comparison:** Comparing original vs fine-tuned models
- **Infrastructure as Code:** Complete Terraform deployment
- **Best Practices:** GPU utilization, resource management, monitoring

## 📚 Documentation

### For Beginners
- **[TUTORIAL_FOR_BEGINNERS.md](./TUTORIAL_FOR_BEGINNERS.md)** ⭐ Start Here!
  - Complete beginner-friendly tutorial
  - Explains all concepts from scratch
  - Problems faced and solutions
  - Zero to hero guide

### For Demo/Presentation
- **[DEMO_POWERPOINT_PRESENTATION.md](./DEMO_POWERPOINT_PRESENTATION.md)**
  - 20-slide presentation
  - Ready to convert to PowerPoint

- **[DEMO_WALKTHROUGH_STEP_BY_STEP.md](./DEMO_WALKTHROUGH_STEP_BY_STEP.md)**
  - 60-minute demo script
  - Exact commands and talking points

### Technical Documentation
- **[COMPLETE_DEPLOYMENT_GUIDE.md](./COMPLETE_DEPLOYMENT_GUIDE.md)**
  - Full deployment instructions

- **[COMPLETE_WORKFLOW_SCRIPTS.md](./COMPLETE_WORKFLOW_SCRIPTS.md)**
  - Enhanced scripts documentation

## 🚀 Quick Start

### Prerequisites
- Terraform 1.8.5+
- Nebius CLI installed
- kubectl installed
- yq installed

### Deployment
```bash
cd soperator/installations/demo
export PATH="/Users/admin/.config/tfenv/versions/1.8.5:$PATH"
source ~/.nebius_encrypted_credentials.sh
source .envrc
terraform init -reconfigure
terraform apply -auto-approve
```

### Running Training
```bash
# SSH into cluster
ssh root@<login-ip>

# Upload scripts
scp -r soperator/installations/demo/training root@<login-ip>:/opt/demo/

# Run training
cd /opt/demo/training
sbatch train_with_original_save.sh
```

## 📊 Key Features

- ✅ 16x H100 GPUs with Fabric-6 Infiniband
- ✅ Separate filesystems for training/inference
- ✅ Automatic model preservation (original + trained)
- ✅ Complete comparison workflow
- ✅ GPU utilization monitoring
- ✅ Full documentation and tutorials

## 📁 Project Structure

```
nebius-assignment/
├── TUTORIAL_FOR_BEGINNERS.md          # Beginner tutorial
├── DEMO_POWERPOINT_PRESENTATION.md     # Presentation slides
├── DEMO_WALKTHROUGH_STEP_BY_STEP.md    # Demo script
├── soperator/                          # Terraform configurations
│   └── installations/demo/
│       ├── training/                    # Training scripts
│       ├── inference/                  # Inference scripts
│       └── comparison/                # Comparison scripts
└── README.md                           # This file
```

## 🛠️ Technologies Used

- **Terraform:** Infrastructure as Code
- **Kubernetes:** Container orchestration
- **Slurm:** Job scheduling
- **PyTorch:** Deep learning framework
- **NCCL:** GPU communication
- **Nebius Cloud:** GPU cloud provider

## 📝 License

This project is for educational/demonstration purposes.

## 🤝 Contributing

This is a demonstration project. Feel free to use it as a learning resource!

## 📞 Support

See [TUTORIAL_FOR_BEGINNERS.md](./TUTORIAL_FOR_BEGINNERS.md) for detailed explanations and troubleshooting.
