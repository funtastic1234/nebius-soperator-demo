# Finding Your Tenant ID from Nebius Console

You're accessing: https://console.nebius.com/project-e00pr6smpr00520mtjnf6q

## Method 1: From the URL

When you're logged into the Nebius Console, check the URL in your browser:

1. **Look at the full URL** - it might look like:
   ```
   https://console.nebius.com/tenant-XXXXX/project-e00pr6smpr00520mtjnf6q
   ```
   The part that starts with `tenant-` is your Tenant ID!

2. **If you don't see it in the URL**, try navigating:
   - Go to the main console: https://console.nebius.com
   - The URL should show: `https://console.nebius.com/tenant-XXXXX/...`

## Method 2: From Console UI

1. **Click on your profile icon** (usually top-right corner)
2. Look for:
   - "Tenant" information
   - "Organization" details
   - "Account" settings
3. The Tenant ID will be displayed (starts with `tenant-`)

## Method 3: From Project Settings

1. In the project page (https://console.nebius.com/project-e00pr6smpr00520mtjnf6q)
2. Look for:
   - Project settings
   - Project details
   - Parent/organization information
3. The tenant ID might be shown as the "parent" or "organization" ID

## Method 4: Using Browser Developer Tools

1. Open browser developer tools (F12 or Cmd+Option+I)
2. Go to Network tab
3. Refresh the page
4. Look at API requests - they often include the tenant ID in headers or URLs

## Quick Test

Once you have your tenant ID, test it:

```bash
# Set your tenant ID
export NEBIUS_TENANT_ID="tenant-XXXXX"  # Replace with actual ID
export NEBIUS_PROJECT_ID="project-e00pr6smpr00520mtjnf6q"

# If you have Nebius CLI installed:
nebius iam whoami
```

## Next Steps

Once you have your Tenant ID:

1. **Run the interactive script:**
   ```bash
   cd /Users/admin/Desktop/nebius-assignment
   ./get-credentials.sh
   ```
   Enter your tenant ID when prompted.

2. **Or set manually:**
   ```bash
   export NEBIUS_TENANT_ID="tenant-XXXXX"
   export NEBIUS_PROJECT_ID="project-e00pr6smpr00520mtjnf6q"
   
   # Get IAM token
   nebius iam token create
   export NEBIUS_IAM_TOKEN=$(nebius iam get-access-token)
   ```

## Still Can't Find It?

If you can't find the tenant ID:
1. Check the browser URL when you first log in
2. Look in the console's "Settings" or "Account" section
3. Contact Nebius support through the console
4. The tenant ID might be in your invitation email

