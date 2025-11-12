# Nebius Credentials Setup

## Your Credentials

- **Tenant ID**: tenant-e00hnw9t8x3etx9frk
- **Project ID**: project-e00pr6smpr00520mtjnf6q

## Quick Setup

### Step 1: Install Nebius CLI

If not installed:
```bash
# Visit: https://nebius.com/docs/cli/quickstart
# Or check: brew install nebius
```

### Step 2: Run Setup Script

```bash
cd /Users/admin/Desktop/nebius-assignment
./install-and-setup.sh
```

This will:
- ✓ Authenticate with Nebius
- ✓ Get IAM token
- ✓ Save credentials to: ~/.nebius_encrypted_credentials.sh

### Step 3: Use Credentials

```bash
source ~/.nebius_encrypted_credentials.sh
```

## Credentials File Location

Credentials are saved to: `~/.nebius_encrypted_credentials.sh`

- File permissions: 600 (read/write owner only)
- Contains: Tenant ID, Project ID, IAM Token
- Auto-refreshes token when sourced

## Refresh Token

If token expires:
```bash
source ~/.nebius_encrypted_credentials.sh
refresh_iam_token
```

## Next Steps

After credentials are set:
```bash
cd soperator/installations/demo
source .envrc
terraform init
terraform apply
```

