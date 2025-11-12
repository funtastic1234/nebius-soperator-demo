# Install Nebius CLI - Step by Step

Since Nebius CLI is not in Homebrew, follow these steps:

## Quick Installation (5 minutes)

### Step 1: Download Nebius CLI

1. **Open your browser** and go to:
   ```
   https://nebius.com/docs/cli/install
   ```

2. **Find the macOS download** section
   - Look for "macOS" or "Darwin" 
   - Your system is **arm64** (Apple Silicon)
   - Download the appropriate binary

3. **Or try direct download** (if available):
   ```bash
   # For Apple Silicon (arm64)
   curl -L -o nebius.tar.gz "https://storage.nebius.cloud/nebius-cli/releases/latest/nebius-cli-darwin-arm64.tar.gz"
   
   # Extract
   tar -xzf nebius.tar.gz
   ```

### Step 2: Install to PATH

```bash
# Option A: System-wide (requires sudo)
sudo mv nebius /usr/local/bin/

# Option B: User directory (no sudo needed)
mkdir -p ~/bin
mv nebius ~/bin/
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Step 3: Verify Installation

```bash
nebius version
# or
nebius --version
```

If this works, you're ready!

### Step 4: Complete Setup

Once CLI is installed, run:

```bash
cd /Users/admin/Desktop/nebius-assignment
./auto-setup-all.sh
```

This will:
- ✓ Authenticate with Nebius
- ✓ Get IAM token  
- ✓ Save to encrypted credentials file
- ✓ Verify access
- ✓ Set up everything for Terraform

## Alternative: Manual Installation

If the download page doesn't work:

1. Contact Nebius support through the console
2. Ask for the CLI binary download link
3. Or check if there's a GitHub repository with releases

## What's Already Ready

- ✓ Tenant ID: `tenant-e00hnw9t8x3etx9frk`
- ✓ Project ID: `project-e00pr6smpr00520mtjnf6q`
- ✓ Credentials file structure: `~/.nebius_encrypted_credentials.sh`
- ✓ Automated setup script: `auto-setup-all.sh`
- ✓ Terraform configuration: `soperator/installations/demo/`

Once CLI is installed, everything else is automated!

