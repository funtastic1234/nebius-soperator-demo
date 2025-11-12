# Accessing Nebius Sandbox - Step by Step

This guide will help you access your Nebius sandbox and get the credentials you need.

## Step 1: Access the Sandbox

1. **Click the invitation link** from your email:
   ```
   https://email.nebius.com/e3t/Ctc/X+113/d38dPw04/...
   ```

2. **Or access directly via Nebius Console:**
   - Go to: https://console.nebius.com
   - Log in with your credentials

3. **Navigate to your project:**
   - The project ID from the assignment is: `project-e00pr6smpr00520mtjnf6q`
   - URL: https://console.nebius.com/project-e00pr6smpr00520mtjnf6q

## Step 2: Find Your Tenant ID

### Method 1: From Console URL
1. After logging in, look at the URL in your browser
2. It will look like: `https://console.nebius.com/tenant-XXXXX/project-YYYYY`
3. The **tenant ID** is the part that starts with `tenant-`

### Method 2: From Console UI
1. Click on your **profile/account** icon (top right)
2. Look for **"Tenant"** or **"Organization"** information
3. The tenant ID will be displayed (starts with `tenant-`)

### Method 3: Using Nebius CLI (if installed)
```bash
nebius iam tenant list
# or
nebius iam whoami
```

## Step 3: Get IAM Token

### Option A: Using Nebius CLI (Recommended)

1. **Install Nebius CLI** (if not installed):
   ```bash
   # macOS
   brew install nebius
   
   # Or follow: https://nebius.com/docs/cli/quickstart
   ```

2. **Authenticate:**
   ```bash
   nebius iam token create
   ```
   This will open a browser for authentication. Follow the prompts.

3. **Get your token:**
   ```bash
   nebius iam get-access-token
   ```

4. **Verify authentication:**
   ```bash
   nebius iam whoami
   ```

### Option B: From Console (Manual)

1. **Go to Nebius Console**: https://console.nebius.com
2. **Navigate to IAM**:
   - Click on your profile icon
   - Go to "IAM" or "Access Management"
   - Look for "Service Accounts" or "API Keys"
3. **Create a Service Account** (if needed):
   - Create a new service account
   - Generate an API key
   - Download the JSON key file
4. **Or use OAuth Token**:
   - Some consoles allow generating OAuth tokens directly
   - Look for "API Access" or "Tokens" section

### Option C: Using Service Account JSON

If you have a service account JSON file:

1. **Set environment variable:**
   ```bash
   export NEBIUS_SERVICE_ACCOUNT_KEY_FILE="/path/to/key.json"
   ```

2. **Use with Nebius CLI:**
   ```bash
   nebius config profile create --name sandbox --service-account-key-file /path/to/key.json
   nebius config profile activate sandbox
   ```

## Step 4: Verify Access

Test that you have the correct credentials:

```bash
# Set your tenant ID
export NEBIUS_TENANT_ID="tenant-XXXXX"  # Replace with your actual tenant ID
export NEBIUS_PROJECT_ID="project-e00pr6smpr00520mtjnf6q"

# Get token
export NEBIUS_IAM_TOKEN=$(nebius iam get-access-token)

# Verify
nebius iam whoami
nebius iam project get --id project-e00pr6smpr00520mtjnf6q
```

## Step 5: Quick Setup Script

Run this to set everything up:

```bash
cd /Users/admin/Desktop/nebius-assignment

# Interactive setup
echo "Enter your Nebius Tenant ID (starts with 'tenant-'):"
read NEBIUS_TENANT_ID

export NEBIUS_TENANT_ID
export NEBIUS_PROJECT_ID="project-e00pr6smpr00520mtjnf6q"

# Authenticate with Nebius CLI
if command -v nebius &> /dev/null; then
    echo "Authenticating with Nebius..."
    nebius iam token create
    export NEBIUS_IAM_TOKEN=$(nebius iam get-access-token)
    echo "✓ Authentication successful"
    nebius iam whoami
else
    echo "Nebius CLI not found. Please install it or provide IAM token manually."
    echo "Enter your IAM token:"
    read NEBIUS_IAM_TOKEN
    export NEBIUS_IAM_TOKEN
fi

# Save to file
cat > /tmp/nebius_credentials.sh <<EOF
export NEBIUS_TENANT_ID="$NEBIUS_TENANT_ID"
export NEBIUS_PROJECT_ID="$NEBIUS_PROJECT_ID"
export NEBIUS_IAM_TOKEN="$NEBIUS_IAM_TOKEN"
EOF

echo ""
echo "✓ Credentials saved to /tmp/nebius_credentials.sh"
echo "  Source it with: source /tmp/nebius_credentials.sh"
```

## Common Issues

### "Tenant not found"
- Verify you're using the correct tenant ID
- Check that you have access to the sandbox
- Contact Nebius support if the invitation link doesn't work

### "Authentication failed"
- Make sure Nebius CLI is installed: `which nebius`
- Try re-authenticating: `nebius iam token create`
- Check token expiration

### "Project not found"
- Verify project ID: `project-e00pr6smpr00520mtjnf6q`
- Check you have access to this project in the console
- Verify you're in the correct tenant

## Next Steps

Once you have your credentials:

1. **Set environment variables:**
   ```bash
   source /tmp/nebius_credentials.sh
   # or manually:
   export NEBIUS_TENANT_ID="tenant-XXXXX"
   export NEBIUS_PROJECT_ID="project-e00pr6smpr00520mtjnf6q"
   export NEBIUS_IAM_TOKEN=$(nebius iam get-access-token)
   ```

2. **Deploy the cluster:**
   ```bash
   cd soperator/installations/demo
   source .envrc
   terraform init
   terraform apply
   ```

## Need Help?

If you're still having trouble:
1. Check the Nebius Console: https://console.nebius.com
2. Review Nebius CLI docs: https://nebius.com/docs/cli/quickstart
3. Contact Nebius support through the console

