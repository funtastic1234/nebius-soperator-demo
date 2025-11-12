# Quick Start - You're in the Console!

You've accessed: **https://console.nebius.com/project-e00pr6smpr00520mtjnf6q**

## Step 1: Find Your Tenant ID (30 seconds)

### Option A: Check the URL
Look at your browser's address bar. The URL might show:
```
https://console.nebius.com/tenant-XXXXX/project-e00pr6smpr00520mtjnf6q
```
The `tenant-XXXXX` part is your Tenant ID!

### Option B: Check Profile
1. Click your **profile icon** (top-right)
2. Look for **"Tenant"** or **"Organization"**
3. Copy the ID (starts with `tenant-`)

### Option C: Check Project Details
1. In the project page, look for:
   - Project settings
   - Project information
   - Parent/organization
2. The tenant ID might be listed there

## Step 2: Get IAM Token

### If you have Nebius CLI installed:

```bash
# Authenticate (opens browser)
nebius iam token create

# Get token
export NEBIUS_TENANT_ID="tenant-XXXXX"  # From Step 1
export NEBIUS_PROJECT_ID="project-e00pr6smpr00520mtjnf6q"
export NEBIUS_IAM_TOKEN=$(nebius iam get-access-token)

# Verify
nebius iam whoami
```

### If you DON'T have Nebius CLI:

1. **Install it first:**
   - Follow: https://nebius.com/docs/cli/quickstart
   - Or check if available: `brew install nebius`

2. **Or use Service Account:**
   - In console: IAM → Service Accounts
   - Create a service account
   - Generate API key
   - Download JSON file

## Step 3: Run Interactive Setup

Once you have your Tenant ID:

```bash
cd /Users/admin/Desktop/nebius-assignment
./get-credentials.sh
```

Enter your tenant ID when prompted. The script will:
- ✓ Save your credentials
- ✓ Get your IAM token
- ✓ Verify access
- ✓ Set up everything for Terraform

## Step 4: Deploy!

After credentials are set:

```bash
cd soperator/installations/demo
source .envrc
terraform init
terraform apply
```

## What You Should See in Console

When you're in the console at `project-e00pr6smpr00520mtjnf6q`, you should see:
- Project dashboard
- Resources (if any exist)
- IAM settings
- Compute resources
- Storage

## Quick Checklist

- [ ] Found Tenant ID (starts with `tenant-`)
- [ ] Installed Nebius CLI (or have service account)
- [ ] Ran `./get-credentials.sh`
- [ ] Credentials saved
- [ ] Ready to deploy!

## Need Help?

- **Can't find Tenant ID?** See `FIND_TENANT_ID.md`
- **CLI issues?** See `ACCESS_SANDBOX_GUIDE.md`
- **Full guide?** See `COMPLETE_DEPLOYMENT_GUIDE.md`

---

**Next:** Run `./get-credentials.sh` and enter your tenant ID! 🚀

