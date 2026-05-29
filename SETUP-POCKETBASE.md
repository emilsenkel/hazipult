## HáziPult - Self-Hosted Setup with PocketBase (Mac Mini)

This guide lets your 13-year-old use HáziPult from **anywhere** with real cloud saving and photo attachments. Everything runs on your Mac Mini.

### 1. Install PocketBase on the Mac Mini

```bash
# 1. Go to a good folder
mkdir -p ~/pocketbase
cd ~/pocketbase

# 2. Download the latest PocketBase for macOS (Apple Silicon or Intel)
# For Apple Silicon (M1/M2/M3/M4):
curl -L https://github.com/pocketbase/pocketbase/releases/download/v0.22.20/pocketbase_0.22.20_darwin_arm64.zip -o pocketbase.zip

# For Intel Macs:
# curl -L https://github.com/pocketbase/pocketbase/releases/download/v0.22.20/pocketbase_0.22.20_darwin_amd64.zip -o pocketbase.zip

unzip pocketbase.zip
chmod +x pocketbase
rm pocketbase.zip

# 3. Start it (first time)
./pocketbase serve
```

Open http://localhost:8090/_/ in your browser to access the admin panel.

Create an admin account.

### 2. Create the Database Collection

In the admin panel:

1. Go to **Collections**
2. Create new collection called `assignments`
3. Add these fields:

| Field Name    | Type     | Required | Options |
|---------------|----------|----------|---------|
| user_id       | text     | yes      | -       |
| subject       | text     | yes      | -       |
| title         | text     | yes      | -       |
| notes         | text     | no       | -       |
| due_date      | date     | yes      | -       |
| priority      | text     | yes      | -       |
| completed     | bool     | yes      | default: false |
| completed_at  | date     | no       | -       |
| image         | file     | no       | max 5 files, images only |

4. Go to **API Rules** and set:
   - List/Search: `@request.auth.id != "" || @request.data.user_id = @request.data.user_id` (or use simple rules for now)

For simplicity during testing, you can temporarily set all rules to public, then lock them down later.

### 3. Enable File Storage (for photos)

PocketBase automatically supports file uploads in the `image` field.

### 4. Expose it to the Internet (Recommended: Cloudflare Tunnel)

This is the safest and easiest way.

```bash
# Install cloudflared (one time)
brew install cloudflare/cloudflare/cloudflared

# Login
cloudflared tunnel login

# Create a tunnel
cloudflared tunnel create hazipult

# Get the tunnel ID from the output, then route it
cloudflared tunnel route dns <tunnel-id> hazipult.yourdomain.com

# Run the tunnel (pointing to PocketBase on port 8090)
cloudflared tunnel run --url http://localhost:8090 <tunnel-id>
```

You can also run it as a service.

Once done, your PocketBase will be available at `https://hazipult.yourdomain.com`

### 5. Update the HáziPult App

In the app, go to the Cloud settings and enter:
- PocketBase URL: `https://hazipult.yourdomain.com`
- (Auth will be added in next version)

The app will then save everything to your Mac Mini from anywhere.

---

**Security note**: Since this is for one child, you can start with very permissive rules and tighten them later.

For the 13-year-old: He only needs to use the normal app. Parents handle this setup once.