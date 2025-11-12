# Nebius Soperator Tutorial
## A Complete Guide for Beginners

**Welcome!** This tutorial will teach you everything about deploying and using Nebius Soperator for distributed machine learning. Even if you've never used these tools before, by the end you'll understand everything!

---

## Table of Contents

1. [What Are We Building?](#what-are-we-building)
2. [Understanding the Tools](#understanding-the-tools)
3. [Setting Up Your Computer](#setting-up-your-computer)
4. [Understanding the Cloud](#understanding-the-cloud)
5. [What is Terraform?](#what-is-terraform)
6. [What is Kubernetes?](#what-is-kubernetes)
7. [What is Slurm?](#what-is-slurm)
8. [What is Distributed Training?](#what-is-distributed-training)
9. [Step-by-Step Setup](#step-by-step-setup)
10. [Problems We Faced and How We Solved Them](#problems-we-faced)
11. [Running Your First Training Job](#running-your-first-training-job)
12. [Comparing Models](#comparing-models)
13. [What You Learned](#what-you-learned)

---

## What Are We Building?

### The Big Picture

Imagine you want to train a really smart AI model (like ChatGPT or an image recognition system). This model is so big and complex that:

1. **It needs lots of computing power** - More than one computer can provide
2. **It needs special graphics cards (GPUs)** - Like the ones in gaming computers, but much more powerful
3. **It needs to run for hours or days** - Training takes time!

**What we're building:** A system that automatically:
- Creates a "supercomputer" in the cloud
- Connects multiple powerful computers together
- Manages training jobs automatically
- Lets you compare different versions of your AI model

### Real-World Example

Think of it like a **baking competition**:
- **One chef (one computer):** Takes 10 hours to bake 100 cakes
- **16 chefs working together (16 GPUs):** Takes 40 minutes to bake 100 cakes!

That's what distributed training does - it splits the work across many computers.

---

## Understanding the Tools

### 1. What is "The Cloud"?

**Simple Explanation:**
The cloud is like renting a super powerful computer over the internet instead of buying one.

**Real Example:**
- **Your laptop:** Like a bicycle - you own it, but it's limited
- **The cloud:** Like renting a race car - you don't own it, but it's super fast when you need it

**Why use the cloud?**
- GPUs are expensive ($10,000+ each!)
- You only pay when you use them
- You can get access to 16 GPUs instantly
- No need to buy and maintain hardware

### 2. What is Nebius?

**Nebius** is a cloud company (like Amazon AWS or Google Cloud) that specializes in:
- **AI/ML workloads** - Perfect for training AI models
- **GPU computing** - Powerful graphics cards for AI
- **High-speed networking** - Fast connections between computers

Think of Nebius as a **specialized AI cloud provider**.

### 3. What is Terraform?

**Simple Explanation:**
Terraform is like a **recipe book** for building computer systems. Instead of clicking buttons in a website, you write code that says "I want 2 computers with 8 GPUs each."

**Real Example:**
- **Without Terraform:** You click 50 buttons in a website to set up everything
- **With Terraform:** You write one file, run one command, and everything is set up automatically!

**Why Terraform?**
- **Reproducible:** You can build the same system again and again
- **Version controlled:** You can save your "recipe" and share it
- **Automated:** No manual clicking and mistakes

**Example Terraform Code:**
```hcl
# This is like a recipe that says:
# "I want 2 computers, each with 8 GPUs"

resource "gpu_computer" "worker" {
  count = 2
  gpus_per_computer = 8
}
```

### 4. What is Kubernetes?

**Simple Explanation:**
Kubernetes (often called "K8s") is like a **smart manager** for a bunch of computers. It decides:
- Which computer should run which program
- What to do if a computer breaks
- How to share resources fairly

**Real Example:**
Imagine a **restaurant manager**:
- **Without manager:** Chefs argue about who does what, food gets burned
- **With manager:** Tasks are assigned, everything runs smoothly, if one chef is sick, another takes over

**Why Kubernetes?**
- **Automatic management:** No need to manually assign tasks
- **Reliability:** If something breaks, it fixes itself
- **Scaling:** Easy to add more computers when needed

### 5. What is Slurm?

**Simple Explanation:**
Slurm is a **job scheduler** - like a smart queue system for computer tasks.

**Real Example:**
Think of a **coffee shop**:
- **Without Slurm:** Everyone rushes to the counter, chaos!
- **With Slurm:** You take a number, wait your turn, get served when resources are available

**Why Slurm?**
- **Fair sharing:** Everyone gets a turn
- **Efficient:** Uses all computers optimally
- **Job management:** Can pause, resume, cancel jobs

### 6. What is Soperator?

**Soperator = Slurm + Kubernetes**

It's a **combination** that gives you:
- **Kubernetes benefits:** Modern, cloud-native, automatic management
- **Slurm benefits:** Perfect for scientific computing and AI training

Think of it as getting the **best of both worlds**!

---

## Understanding Distributed Training

### What is Machine Learning?

**Simple Explanation:**
Machine learning is teaching a computer to recognize patterns by showing it lots of examples.

**Real Example:**
- **Teaching a child:** Show them 1000 pictures of cats, they learn what a cat looks like
- **Training an AI:** Show a computer 1 million pictures of cats, it learns to recognize cats

### What is Training?

**Training** is the process of teaching the AI model:
1. **Input:** Show the model data (pictures, text, etc.)
2. **Process:** Model makes a guess
3. **Compare:** Check if guess was right
4. **Adjust:** Fix the model's "brain" (weights)
5. **Repeat:** Do this millions of times

### What is Distributed Training?

**Simple Explanation:**
Instead of one computer doing all the work, **split the work across many computers**.

**Real Example:**
- **One person:** Reads 1000 books in 1000 days
- **10 people:** Each reads 100 books, done in 100 days!

**How it works:**
1. **Split the data:** Divide your training data into chunks
2. **Each GPU trains:** Each computer works on its chunk
3. **Share results:** Computers share what they learned
4. **Combine:** Merge all the learning into one model

### Why 16 GPUs?

**GPUs (Graphics Processing Units)** are special chips that are **super fast** at the math needed for AI.

**Why 16?**
- **Speed:** 16 GPUs = 16x faster (roughly)
- **Efficiency:** Better use of resources
- **Cost:** Still affordable, but very powerful

**Real Numbers:**
- **1 GPU:** Trains a model in 16 hours
- **16 GPUs:** Trains the same model in 1 hour!

---

## Setting Up Your Computer

### Step 1: Install Basic Tools

#### What is a Terminal/Command Line?

**Simple Explanation:**
Instead of clicking icons, you type commands. It's like texting your computer!

**Why use it?**
- **Faster:** Type one command instead of clicking 10 times
- **Powerful:** Can automate things
- **Professional:** Most developers use it

**Example:**
```bash
# Instead of clicking "Open Folder", you type:
cd Desktop

# Instead of clicking "List Files", you type:
ls
```

#### Installing Tools

**1. Homebrew (Mac Package Manager)**
```bash
# This is like an "App Store" for developers
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**What it does:** Lets you install other tools easily

**2. Terraform**
```bash
# Install Terraform version manager
brew install tfenv

# Install Terraform 1.8.5 (the version we need)
tfenv install 1.8.5
tfenv use 1.8.5
```

**What it does:** Tool for building cloud infrastructure

**3. yq (YAML Processor)**
```bash
brew install yq
```

**What it does:** Helps read/write configuration files

**4. kubectl (Kubernetes Command Tool)**
```bash
brew install kubectl
```

**What it does:** Lets you control your Kubernetes cluster

### Step 2: Install Nebius CLI

**What is a CLI?**
CLI = Command Line Interface. It's a program you run from the terminal.

**Installation:**
```bash
curl -sSL https://storage.eu-north1.nebius.cloud/cli/install.sh | bash
```

**What it does:** Lets you talk to Nebius cloud from your computer

**Verify:**
```bash
nebius version
```

---

## Understanding the Cloud

### What is a Tenant?

**Simple Explanation:**
A tenant is like your **account** or **workspace** in the cloud.

**Real Example:**
- **Gmail account:** You have your own inbox, contacts, etc.
- **Nebius tenant:** You have your own resources, projects, etc.

**Your tenant ID:** `tenant-e00hnw9t8x3etx9frk`
- This is like your username - unique to you

### What is a Project?

**Simple Explanation:**
A project is like a **folder** where you put related things together.

**Real Example:**
- **School folder:** All your math homework goes in one folder
- **Nebius project:** All resources for one task go in one project

**Your project ID:** `project-e00pr6smpr00520mtjnf6q`

### What is an IAM Token?

**Simple Explanation:**
An IAM token is like a **password** that proves you're allowed to use the cloud.

**Real Example:**
- **School ID card:** Proves you're a student
- **IAM token:** Proves you're allowed to use Nebius

**How to get one:**
```bash
nebius iam get-access-token
```

This gives you a token that works for a limited time (like a temporary password).

### What is a VPC Subnet?

**Simple Explanation:**
A VPC (Virtual Private Cloud) is like a **private network** for your computers.

**Real Example:**
- **Public WiFi:** Anyone can connect (not secure)
- **Private network:** Only your computers can talk to each other (secure)

**Why it matters:** Your training computers need to talk to each other securely and fast.

---

## What is Terraform? (Deep Dive)

### How Terraform Works

**Step 1: Write Configuration**
You write a file (like a recipe) describing what you want:
```hcl
resource "gpu_cluster" "my_cluster" {
  name = "my-awesome-cluster"
  gpus = 16
}
```

**Step 2: Terraform Plans**
Terraform reads your file and says:
- "I need to create 1 GPU cluster with 16 GPUs"
- "This will cost $X per hour"
- "This will take Y minutes"

**Step 3: You Approve**
You say "Yes, do it!"

**Step 4: Terraform Creates**
Terraform talks to the cloud and creates everything automatically.

**Step 5: Terraform Remembers**
Terraform saves what it created, so it knows what to update or delete later.

### Terraform Files Explained

**1. `terraform.tfvars` - Your Settings**
```hcl
# This is like filling out a form
company_name = "demo"
region = "eu-north1"
gpu_count = 16
```

**2. `main.tf` - The Recipe**
```hcl
# This describes WHAT to build
module "cluster" {
  source = "./modules/cluster"
  gpu_count = var.gpu_count
}
```

**3. `variables.tf` - The Form Fields**
```hcl
# This defines what settings you can change
variable "gpu_count" {
  description = "How many GPUs do you want?"
  type = number
}
```

### Terraform State

**What is State?**
State is Terraform's **memory** - it remembers what it created.

**Why it matters:**
- If you run Terraform again, it knows what already exists
- It can update things instead of creating duplicates
- It knows what to delete when you're done

**Where is it stored?**
Usually in cloud storage (like S3) so it's safe and shared.

---

## What is Kubernetes? (Deep Dive)

### Kubernetes Architecture

**Master Node (Control Plane):**
- The **brain** of the system
- Makes decisions about what runs where
- Manages the cluster

**Worker Nodes:**
- The **muscle** of the system
- Actually run your programs
- Do the computing work

**Pods:**
- The **smallest unit** in Kubernetes
- Like a container running a program
- Can be moved between nodes

**Services:**
- How pods **talk to each other**
- Like phone numbers - you call a service, it routes to the right pod

### Why Kubernetes for AI?

**1. Automatic Scaling:**
- Need more GPUs? Kubernetes adds them automatically
- Done training? Kubernetes removes them to save money

**2. Reliability:**
- If a computer crashes, Kubernetes starts your program on another computer
- No manual intervention needed

**3. Resource Management:**
- Kubernetes ensures fair sharing
- No one program hogs all the resources

---

## What is Slurm? (Deep Dive)

### How Slurm Works

**1. You Submit a Job:**
```bash
sbatch my_training_script.sh
```

**2. Slurm Queues It:**
- Slurm looks at available resources
- Puts your job in a queue if resources are busy
- Assigns resources when available

**3. Slurm Runs It:**
- Starts your job on the assigned computers
- Monitors it while it runs
- Saves output when done

**4. You Get Results:**
- Check job status: `squeue`
- View output: `cat job_output.txt`
- Cancel if needed: `scancel job_id`

### Slurm Job Script

**What is a Job Script?**
A job script tells Slurm:
- How many computers you need
- How many GPUs you need
- How long it will take
- What command to run

**Example:**
```bash
#!/bin/bash
#SBATCH --job-name=my-training
#SBATCH --nodes=2          # I need 2 computers
#SBATCH --gres=gpu:8       # Each needs 8 GPUs
#SBATCH --time=06:00:00    # It will take 6 hours

# This is the actual command to run
python train_model.py
```

**Breaking it down:**
- `#SBATCH` = Instructions for Slurm
- `--nodes=2` = "I need 2 computers"
- `--gres=gpu:8` = "Each computer needs 8 GPUs"
- `--time=06:00:00` = "Reserve 6 hours"

---

## Step-by-Step Setup

### Phase 1: Getting Access

#### Step 1.1: Get Your Tenant ID

**What is a Tenant ID?**
Your unique identifier in Nebius cloud.

**How to find it:**
1. Go to https://console.nebius.com
2. Look at the URL or account settings
3. It looks like: `tenant-xxxxxxxxxxxxx`

**Why you need it:**
Terraform needs to know which account to use.

#### Step 1.2: Get Your IAM Token

**What is an IAM Token?**
A temporary password that proves you're allowed to use Nebius.

**How to get it:**
```bash
# First, make sure Nebius CLI is installed
nebius version

# Then get your token
nebius iam get-access-token
```

**What you'll see:**
```
yq_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

**Save it securely!** You'll need it for Terraform.

#### Step 1.3: Save Credentials

**Why save them?**
So you don't have to type them every time.

**How to save:**
```bash
# Create a secure file
cat > ~/.nebius_encrypted_credentials.sh << 'EOF'
export NEBIUS_TENANT_ID="tenant-e00hnw9t8x3etx9frk"
export NEBIUS_PROJECT_ID="project-e00pr6smpr00520mtjnf6q"
export NEBIUS_IAM_TOKEN="your-token-here"
EOF

# Make it secure (only you can read it)
chmod 600 ~/.nebius_encrypted_credentials.sh

# Use it
source ~/.nebius_encrypted_credentials.sh
```

### Phase 2: Understanding the Configuration

#### What is terraform.tfvars?

**Simple Explanation:**
This is like a **settings file** - you fill in your preferences.

**Key Settings Explained:**

```hcl
company_name = "demo"
```
**What it means:** A name for your deployment (like naming a project folder)

```hcl
region = "eu-north1"
```
**What it means:** Which data center to use (like choosing a location)
- **Why it matters:** Closer = faster, but some regions have different resources

```hcl
slurm_nodeset_workers = [{
  name = "worker",
  size = 2,
  resource = {
    platform = "gpu-h100-sxm",
    preset = "8gpu-128vcpu-1600gb"
  }
}]
```
**Breaking it down:**
- `size = 2` = "I want 2 computers"
- `platform = "gpu-h100-sxm"` = "Use H100 GPUs" (very powerful!)
- `preset = "8gpu-128vcpu-1600gb"` = "Each computer gets 8 GPUs, 128 CPUs, 1600GB RAM"

```hcl
gpu_cluster = {
  infiniband_fabric = "fabric-6"
}
```
**What it means:** Use super-fast networking between computers
- **Why:** Training needs computers to talk to each other very fast
- **fabric-6:** The fastest option available

```hcl
filestore_jail_submounts = [
  { name = "training", mount_path = "/mnt/training" },
  { name = "inference", mount_path = "/mnt/inference" }
]
```
**What it means:** Create shared storage folders
- **training:** Where training data and models go
- **inference:** Where inference results go
- **Why separate:** So they don't interfere with each other

```hcl
public_o11y_enabled = false
```
**What it means:** Don't send monitoring data to public services
- **o11y = Observability:** Monitoring and logging
- **false:** Keep it private (as required by assignment)

### Phase 3: Deploying Infrastructure

#### What Happens When You Run `terraform apply`?

**Step 1: Terraform Reads Your Files**
- Reads `main.tf` (the recipe)
- Reads `terraform.tfvars` (your settings)
- Understands what you want

**Step 2: Terraform Plans**
- Checks what already exists
- Figures out what needs to be created
- Shows you a plan

**Step 3: You Review**
- Terraform shows: "I will create X, Y, Z"
- You check if it looks right
- You approve (or cancel)

**Step 4: Terraform Creates**
- Talks to Nebius cloud
- Creates Kubernetes cluster
- Creates GPU cluster
- Creates worker nodes
- Sets up networking
- Configures storage
- Deploys Slurm

**Step 5: Wait (20-40 minutes)**
- Creating computers takes time!
- Terraform shows progress
- You wait patiently

**Step 6: Done!**
- Everything is created
- You get access information
- Ready to use!

---

## Problems We Faced and How We Solved Them

### Problem 1: "terraform: command not found"

**What happened:**
We tried to run Terraform, but the computer said "I don't know what that is!"

**Why it happened:**
Terraform wasn't installed on the computer.

**How we solved it:**
```bash
# Install tfenv (Terraform version manager)
brew install tfenv

# Install Terraform
tfenv install 1.8.5
tfenv use 1.8.5

# Verify it works
terraform version
```

**What we learned:**
- Tools need to be installed before you can use them
- Version managers help you use the right version

### Problem 2: "nebius: command not found"

**What happened:**
We tried to use Nebius CLI, but it wasn't installed.

**Why it happened:**
Nebius CLI is not in the regular package managers.

**How we solved it:**
```bash
# Install using Nebius's official script
curl -sSL https://storage.eu-north1.nebius.cloud/cli/install.sh | bash

# Add to PATH (so computer can find it)
export PATH="$HOME/.nebius/bin:$PATH"

# Verify
nebius version
```

**What we learned:**
- Some tools have special installation methods
- PATH tells your computer where to find programs

### Problem 3: "yq: command not found"

**What happened:**
A script needed `yq` but it wasn't installed.

**Why it happened:**
`yq` is a tool for reading YAML files, not installed by default.

**How we solved it:**
```bash
brew install yq
```

**What we learned:**
- Different tools do different jobs
- You install what you need as you go

### Problem 4: Terraform Version Compatibility

**What happened:**
Terraform said "Missing newline after argument" for `provider::units::from_gib()`

**Why it happened:**
- The code uses `provider::units::from_gib()` syntax
- This is a NEW feature in Terraform 1.8.0+
- We were using Terraform 1.5.7 (too old!)

**The Error:**
```
Error: Missing newline after argument
  on main.tf line 137:
  137:   size_bytes = provider::units::from_gib(...)
```

**How we solved it:**
```bash
# Upgrade to Terraform 1.8.5
tfenv install 1.8.5
tfenv use 1.8.5

# Verify
terraform version  # Should show 1.8.5
```

**What we learned:**
- **Version compatibility matters!** New features need new versions
- Always check required versions in documentation
- `provider::` syntax is for calling functions from providers (like the units provider)

**Deep Dive: What is `provider::units::from_gib()`?**
- **provider::** = "Call a function from a provider"
- **units** = The units provider (converts between units like GB, MB, etc.)
- **from_gib** = "Convert from Gibibytes to bytes"
- **Why needed:** Cloud APIs need bytes, but we think in GB

### Problem 5: Filesystem Quota Exceeded

**What happened:**
Terraform said "Quota limit exceeded" when trying to create storage.

**Why it happened:**
- We requested 7.28 TiB of storage
- Our quota limit was 5 TiB
- We asked for more than we were allowed!

**The Error:**
```
Error: Quota limit exceeded
  compute.filesystem.size.network-ssd (limit 5497558138880, requested 7284264534016)
```

**How we solved it:**
We reduced the sizes in `terraform.tfvars`:
```hcl
# Before (too big):
filestore_jail.spec.size_gibibytes = 2048
filestore_jail_submounts[0].spec.size_gibibytes = 2048
filestore_jail_submounts[1].spec.size_gibibytes = 2048
# Total: ~6 TiB (exceeded 5 TiB limit)

# After (fits):
filestore_jail.spec.size_gibibytes = 1024
filestore_jail_submounts[0].spec.size_gibibytes = 1024
filestore_jail_submounts[1].spec.size_gibibytes = 1024
# Total: ~3 TiB (within 5 TiB limit)
```

**What we learned:**
- **Quotas exist** - Cloud providers limit what you can use
- **Plan your storage** - Don't request more than you need
- **Check limits first** - Know your quotas before deploying

### Problem 6: Can't Reduce Filesystem Size

**What happened:**
We tried to reduce the size of existing filesystems, but got an error.

**Why it happened:**
- Filesystems were already created at 2048 GiB
- We tried to reduce them to 1024 GiB
- Nebius doesn't allow reducing filesystem size (data safety!)

**The Error:**
```
Error: Size cannot be less than current actual size
```

**How we solved it:**
1. **Removed from Terraform state:**
   ```bash
   terraform state rm 'module.filestore.nebius_compute_v1_filesystem.jail_submount["inference"]'
   ```

2. **Deleted the filesystem manually:**
   ```bash
   nebius compute filesystem delete --id computefilesystem-xxxxx
   ```

3. **Let Terraform recreate it** with the smaller size

**What we learned:**
- **Some operations are one-way** - You can grow storage, but not shrink it
- **State management matters** - Terraform needs to know what exists
- **Manual intervention sometimes needed** - Not everything can be automated

### Problem 7: Missing Terraform Modules

**What happened:**
Terraform said "Unreadable module directory" for some modules.

**Why it happened:**
- The code referenced modules that didn't exist
- Modules like `nfs-server`, `gpu-operator`, `network-operator` were missing

**How we solved it:**
1. **For unused modules:** Set them to disabled in configuration
   ```hcl
   nfs = { enabled = false }
   ```

2. **For required modules:** Created minimal "stub" modules
   - Created empty files that satisfy Terraform's requirements
   - Modules don't do anything, but Terraform is happy

**What we learned:**
- **Modules are reusable code** - Like functions in programming
- **Sometimes you need placeholders** - Even if you don't use them
- **Configuration flexibility** - You can enable/disable features

### Problem 8: Node Groups Already Exist

**What happened:**
Terraform tried to create node groups, but they already existed from a previous attempt.

**Why it happened:**
- We ran Terraform before, it created some resources
- Then we ran it again
- Terraform didn't know about the existing resources

**How we solved it:**
**Imported existing resources into Terraform state:**
```bash
terraform import 'module.k8s.nebius_mk8s_v1_node_group.accounting[0]' mk8snodegroup-xxxxx
terraform import 'module.k8s.nebius_mk8s_v1_node_group.controller' mk8snodegroup-yyyyy
# ... etc
```

**What we learned:**
- **State synchronization** - Terraform needs to know what exists
- **Import is powerful** - You can bring existing resources under Terraform management
- **Idempotency** - Running Terraform multiple times should be safe

---

## Running Your First Training Job

### Step 1: Access the Cluster

**Get the Login IP:**
```bash
# After terraform apply completes
terraform output slurm_login_ip

# Or check the login script
cat ./login.sh
```

**SSH into the Cluster:**
```bash
ssh root@<login-ip> -i ~/.ssh/your-key
```

**What is SSH?**
SSH = Secure Shell. It's like a secure way to connect to another computer over the internet.

**Verify Slurm is Working:**
```bash
sinfo    # Show available nodes
squeue   # Show running jobs
```

### Step 2: Understand the Training Script

**Let's look at `train_with_original_save.sh`:**

```bash
#!/bin/bash
#SBATCH --job-name=training-with-original
#SBATCH --nodes=2          # Use 2 computers
#SBATCH --ntasks-per-node=8  # 8 tasks per computer
#SBATCH --gres=gpu:8      # 8 GPUs per computer
#SBATCH --time=06:00:00   # Reserve 6 hours
```

**What each line means:**
- `#!/bin/bash` = "This is a bash script"
- `#SBATCH` = "This is an instruction for Slurm"
- `--nodes=2` = "I need 2 computers"
- `--gres=gpu:8` = "Each computer needs 8 GPUs"
- `--time=06:00:00` = "This job will take up to 6 hours"

**The Script Does Two Things:**

**Part 1: Save Original Model**
```bash
# Before training, save the original (pretrained) model
# So we can compare it later!
srun --ntasks=1 python3 << 'ORIGINAL_SAVE'
  # Python code that saves the model
  torch.save(original_model, "/mnt/inference/original/original_model.pt")
ORIGINAL_SAVE
```

**Part 2: Run Training**
```bash
# Now run the actual training
srun python3 << 'TRAINING_SCRIPT'
  # Python code that trains the model
  # Uses all 16 GPUs for distributed training
TRAINING_SCRIPT
```

### Step 3: Submit the Job

**Upload Scripts:**
```bash
# From your local computer
scp -r soperator/installations/demo/training root@<login-ip>:/opt/demo/
```

**Submit Job:**
```bash
# On the cluster
cd /opt/demo/training
sbatch train_with_original_save.sh
```

**What happens:**
- Slurm receives your job
- Checks if resources are available
- Queues it if busy, or starts immediately
- Gives you a job ID

**Expected output:**
```
Submitted batch job 12345
```

### Step 4: Monitor the Job

**Check Job Status:**
```bash
squeue -j 12345
```

**Watch Output:**
```bash
tail -f /opt/demo/training/training-12345.out
```

**Monitor GPUs:**
```bash
# Real-time GPU monitoring
watch -n 5 nvidia-smi
```

**What to look for:**
- **GPU Utilization:** Should be >80%
- **Memory Usage:** Should be high (using the GPUs)
- **Temperature:** Should be reasonable
- **Power:** Should be high (GPUs working hard!)

### Step 5: Understand What's Happening

**While Training Runs:**

1. **Data Loading:**
   - Training data is loaded from `/mnt/training/data/`
   - Split across GPUs

2. **Forward Pass:**
   - Each GPU processes its chunk of data
   - Model makes predictions

3. **Backward Pass:**
   - Calculates how wrong the predictions were
   - Calculates gradients (how to fix the model)

4. **Synchronization:**
   - All GPUs share their gradients
   - Average them together
   - Update the model

5. **Repeat:**
   - Do this for many epochs (full passes through data)
   - Model gets better each time

**Why Distributed Training is Fast:**
- **16 GPUs working in parallel** = 16x the work done
- **High-speed networking** = Fast gradient sharing
- **Efficient algorithms** = Minimal communication overhead

---

## Comparing Models

### Why Compare?

**Simple Explanation:**
You want to know: "Did training actually make the model better?"

**Real Example:**
- **Before training:** Model gets 60% of answers right
- **After training:** Model gets 85% of answers right
- **Improvement:** +25%! Training worked!

### Step 1: Run Inference on Original Model

**What is Inference?**
Inference is using the trained model to make predictions on new data.

**Run Inference:**
```bash
cd /opt/demo/inference
sbatch inference_original.sh
```

**What happens:**
1. Loads the original (untrained) model
2. Runs it on test data
3. Saves predictions to `/mnt/inference/results/original/`

### Step 2: Run Inference on Trained Model

**Run Inference:**
```bash
sbatch inference_trained.sh
```

**What happens:**
1. Loads the fine-tuned model
2. Runs it on the **same** test data
3. Saves predictions to `/mnt/inference/results/trained/`

**Why same test data?**
So the comparison is fair! Like testing two students with the same exam.

### Step 3: Compare Results

**Run Comparison:**
```bash
cd /opt/demo/comparison
python3 compare_models.py \
  --trained-results /mnt/inference/results/trained/inference_results.json \
  --original-results /mnt/inference/results/original/inference_results.json \
  --output /mnt/inference/results/comparison_report.json
```

**What the Script Does:**

1. **Loads Both Results:**
   - Reads predictions from original model
   - Reads predictions from trained model

2. **Calculates Metrics:**
   - Mean (average) output
   - Standard deviation (how spread out)
   - Min/Max values

3. **Compares:**
   - Calculates differences
   - Calculates improvement percentage
   - Shows which is better

4. **Saves Report:**
   - Creates a JSON file with all metrics
   - Easy to read and share

**Example Output:**
```json
{
  "trained_model": {
    "mean_output": 0.6789,
    "num_samples": 100
  },
  "original_model": {
    "mean_output": 0.5234,
    "num_samples": 100
  },
  "differences": {
    "improvement_percent": 29.7
  }
}
```

**What this means:**
- Trained model is 29.7% better!
- Training was successful!

---

## Understanding Key Concepts

### What is a Model Checkpoint?

**Simple Explanation:**
A checkpoint is a **saved version** of your model at a specific point in training.

**Why it matters:**
- **If training crashes:** You can resume from the last checkpoint
- **To compare:** You can test different checkpoints
- **To share:** You can give someone a specific version

**Real Example:**
Like saving your game progress - if the game crashes, you don't lose everything!

### What is Fine-tuning?

**Simple Explanation:**
Fine-tuning is taking a model that already knows something and teaching it something new.

**Real Example:**
- **Pretrained model:** Knows general English (like a student who read many books)
- **Fine-tuning:** Teaches it medical terms (like the same student taking a medical course)
- **Result:** Model that understands both general English AND medical terms

**Why it's faster:**
- Don't start from scratch
- Build on existing knowledge
- Much faster than training from zero

### What is GPU Utilization?

**Simple Explanation:**
GPU utilization is how much of the GPU's power you're actually using.

**Real Example:**
- **0% utilization:** GPU is idle (like a car engine off)
- **50% utilization:** GPU is half busy (like driving in city traffic)
- **100% utilization:** GPU is maxed out (like racing on a track)

**Why >80% is good:**
- You're getting your money's worth
- Training is efficient
- No wasted resources

**How to check:**
```bash
nvidia-smi
# Shows: GPU 0: 85% utilization
```

### What is Distributed Data Parallel (DDP)?

**Simple Explanation:**
DDP is a way to train a model across multiple GPUs where:
- Each GPU gets a chunk of data
- Each GPU trains on its chunk
- GPUs share what they learned
- Model is updated with combined learning

**Real Example:**
Like a **study group**:
- Each person studies different chapters
- Everyone shares their notes
- Everyone learns everything!

**Why it's fast:**
- Parallel processing (doing multiple things at once)
- Efficient communication (only sharing what's needed)

---

## Common Commands Reference

### Terraform Commands

```bash
# Initialize Terraform (first time)
terraform init

# Check if configuration is valid
terraform validate

# See what Terraform will do (without doing it)
terraform plan

# Actually create/update resources
terraform apply

# See what exists
terraform state list

# Remove something from Terraform management
terraform state rm <resource>

# Import existing resource
terraform import <resource> <id>

# Destroy everything (be careful!)
terraform destroy
```

### Kubernetes Commands

```bash
# List all nodes
kubectl get nodes

# List all pods
kubectl get pods

# Get detailed info about a pod
kubectl describe pod <pod-name>

# View logs
kubectl logs <pod-name>

# Execute command in a pod
kubectl exec -it <pod-name> -- bash
```

### Slurm Commands

```bash
# Submit a job
sbatch my_script.sh

# List all jobs
squeue

# List your jobs
squeue -u $USER

# Show job details
scontrol show job <job-id>

# Cancel a job
scancel <job-id>

# Show node information
sinfo

# Show detailed node info
scontrol show node <node-name>
```

### GPU Monitoring

```bash
# Show GPU status
nvidia-smi

# Continuous monitoring
watch -n 5 nvidia-smi

# Show GPU utilization only
nvidia-smi --query-gpu=utilization.gpu --format=csv
```

### File Operations

```bash
# List files
ls

# List with details
ls -lh

# Change directory
cd /path/to/directory

# Show current directory
pwd

# Copy file
cp source.txt destination.txt

# Copy directory
cp -r source_dir/ destination_dir/

# Remove file
rm file.txt

# Remove directory
rm -r directory/
```

---

## Troubleshooting Guide

### Problem: Can't SSH into Cluster

**Symptoms:**
```
ssh: connect to host <ip> port 22: Connection refused
```

**Solutions:**
1. **Check if login node is ready:**
   ```bash
   kubectl get pods -n soperator | grep login
   ```

2. **Wait a bit:** Login nodes take time to start

3. **Check firewall:** Make sure port 22 is open

4. **Verify IP:**
   ```bash
   terraform output slurm_login_ip
   ```

### Problem: Training Job Fails

**Symptoms:**
```bash
squeue shows job in FAILED state
```

**Solutions:**
1. **Check error log:**
   ```bash
   cat training-<job-id>.err
   ```

2. **Check output log:**
   ```bash
   cat training-<job-id>.out
   ```

3. **Common issues:**
   - **Out of memory:** Reduce batch size
   - **Missing files:** Check file paths
   - **GPU not found:** Check `--gres=gpu:8` is correct

### Problem: Low GPU Utilization

**Symptoms:**
```bash
nvidia-smi shows 20% utilization
```

**Solutions:**
1. **Check if all GPUs are allocated:**
   ```bash
   scontrol show job <job-id> | grep -i gpu
   ```

2. **Check data loading:**
   - Data loading might be the bottleneck
   - Use faster storage or more workers

3. **Check batch size:**
   - Too small = GPU not fully used
   - Too large = Out of memory

### Problem: Models Not Found

**Symptoms:**
```
FileNotFoundError: original_model.pt not found
```

**Solutions:**
1. **Check if training completed:**
   ```bash
   grep "Training completed" training-*.out
   ```

2. **Check file locations:**
   ```bash
   ls -lh /mnt/training/models/
   ls -lh /mnt/inference/original/
   ```

3. **Verify filesystem mounts:**
   ```bash
   df -h | grep -E "training|inference"
   ```

---

## What You Learned

### Technical Skills

1. **Cloud Computing:**
   - How to use cloud services
   - Understanding tenants, projects, tokens
   - Managing cloud resources

2. **Infrastructure as Code:**
   - Writing Terraform configurations
   - Understanding state management
   - Version control for infrastructure

3. **Container Orchestration:**
   - Kubernetes basics
   - Pods, services, nodes
   - Resource management

4. **Job Scheduling:**
   - Slurm job submission
   - Resource allocation
   - Job monitoring

5. **Distributed Computing:**
   - Multi-GPU training
   - Data parallelism
   - Synchronization

6. **Machine Learning:**
   - Training workflows
   - Model checkpoints
   - Inference pipelines
   - Model comparison

### Problem-Solving Skills

1. **Debugging:**
   - Reading error messages
   - Checking logs
   - Systematic troubleshooting

2. **Version Management:**
   - Understanding compatibility
   - Managing tool versions
   - Dealing with breaking changes

3. **Resource Planning:**
   - Understanding quotas
   - Planning storage needs
   - Cost optimization

4. **Documentation:**
   - Writing clear instructions
   - Creating tutorials
   - Sharing knowledge

### Career Skills

1. **DevOps:**
   - Automation
   - Infrastructure management
   - CI/CD concepts

2. **Cloud Engineering:**
   - Multi-cloud concepts
   - Resource optimization
   - Cost management

3. **ML Engineering:**
   - Training pipelines
   - Model deployment
   - Performance optimization

---

## Next Steps for Learning

### Beginner Level

1. **Learn Linux Basics:**
   - Command line navigation
   - File operations
   - Text editors (vim/nano)

2. **Learn Python:**
   - Basic syntax
   - Libraries (PyTorch, NumPy)
   - Scripting

3. **Learn Git:**
   - Version control basics
   - GitHub/GitLab
   - Collaboration

### Intermediate Level

1. **Docker:**
   - Container basics
   - Building images
   - Docker Compose

2. **Kubernetes Deep Dive:**
   - Advanced concepts
   - Custom resources
   - Operators

3. **Machine Learning:**
   - Model architectures
   - Training techniques
   - Evaluation metrics

### Advanced Level

1. **Distributed Systems:**
   - Consensus algorithms
   - Fault tolerance
   - Scalability patterns

2. **ML at Scale:**
   - Large model training
   - Model serving
   - MLOps

3. **Cloud Architecture:**
   - Multi-region deployments
   - High availability
   - Disaster recovery

---

## Glossary of Terms

**API (Application Programming Interface):** A way for programs to talk to each other

**CLI (Command Line Interface):** Using text commands instead of clicking buttons

**Container:** A package that includes code and everything it needs to run

**CPU (Central Processing Unit):** The main processor in a computer

**GPU (Graphics Processing Unit):** A special processor great at parallel math (used for AI)

**IAM (Identity and Access Management):** System for managing who can do what

**Infiniband:** Super-fast networking technology for connecting computers

**Namespace:** A way to organize resources in Kubernetes

**Pod:** The smallest deployable unit in Kubernetes (contains one or more containers)

**Provider:** A plugin that lets Terraform talk to a specific cloud service

**Quota:** A limit on how much of something you can use

**State:** Terraform's memory of what it has created

**Subnet:** A part of a network

**VPC (Virtual Private Cloud):** A private network in the cloud

**YAML:** A human-readable data format (like JSON but easier to read)

---

## Real-World Applications

### What Can You Build With This?

1. **Image Recognition:**
   - Train a model to recognize objects in photos
   - Use it in security cameras, self-driving cars

2. **Language Models:**
   - Fine-tune GPT for specific tasks
   - Chatbots, translation, summarization

3. **Scientific Computing:**
   - Climate modeling
   - Drug discovery
   - Protein folding

4. **Recommendation Systems:**
   - Netflix movie recommendations
   - Amazon product suggestions
   - Spotify playlists

### Career Paths

**ML Engineer:**
- Build and train AI models
- Deploy models to production
- Optimize performance

**DevOps Engineer:**
- Automate infrastructure
- Manage cloud resources
- Ensure reliability

**Cloud Architect:**
- Design cloud systems
- Plan for scale
- Optimize costs

**Research Scientist:**
- Develop new AI techniques
- Publish papers
- Push boundaries

---

## Final Thoughts

### What Makes This Special?

1. **Real-World Skills:**
   - These are actual tools used in industry
   - Not just theory - hands-on experience

2. **Problem-Solving:**
   - You learned to debug real issues
   - Not everything works the first time
   - Persistence pays off!

3. **Complete Workflow:**
   - From zero to working system
   - End-to-end understanding
   - You can do this yourself now!

### Remember:

- **It's okay to make mistakes** - That's how you learn!
- **Read error messages carefully** - They usually tell you what's wrong
- **Ask for help** - Everyone was a beginner once
- **Practice makes perfect** - The more you do, the easier it gets

### You're Now Ready To:

✅ Deploy cloud infrastructure  
✅ Run distributed training jobs  
✅ Compare model performance  
✅ Troubleshoot issues  
✅ Build real AI systems  

**Congratulations! You've gone from zero to hero! 🎉**

---

## Quick Reference Card

### Essential Commands

```bash
# Terraform
terraform init
terraform validate
terraform apply

# Kubernetes
kubectl get nodes
kubectl get pods

# Slurm
sbatch script.sh
squeue
scancel <job-id>

# Monitoring
nvidia-smi
watch -n 5 nvidia-smi

# File Operations
ls, cd, cp, rm, cat, tail
```

### Key File Locations

```
/mnt/training/          # Training data and models
/mnt/inference/         # Inference results
/opt/demo/              # Demo scripts
~/.nebius_encrypted_credentials.sh  # Your credentials
```

### Important Concepts

- **Terraform:** Infrastructure as code
- **Kubernetes:** Container orchestration
- **Slurm:** Job scheduling
- **DDP:** Distributed training
- **GPU Utilization:** How much GPU is being used
- **Checkpoint:** Saved model state

---

**Good luck with your AI journey! 🚀**

