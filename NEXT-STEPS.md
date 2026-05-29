## Next Steps After Running setup-macmini.sh

You ran the script. Great!

### 1. Check if PocketBase is running

On your Mac Mini, run:

```bash
curl http://localhost:8090
```

If you see JSON, it's working.

### 2. Create Admin Account (Important)

Open in browser on the Mac Mini:

**http://localhost:8090/_/**

Create your admin account if you haven't already.

### 3. Create the Database Collection

In the PocketBase admin panel:

1. Go to **Collections** (left sidebar)
2. Click **New collection**
3. Name it: `assignments`

Add these fields exactly:

| Field Name     | Type     | Required | Options / Notes                  |
|----------------|----------|----------|----------------------------------|
| user_id        | text     | Yes      |                                  |
| subject        | text     | Yes      |                                  |
| title          | text     | Yes      |                                  |
| notes          | text     | No       |                                  |
| due_date       | date     | Yes      |                                  |
| priority       | text     | Yes      | low / medium / high              |
| completed      | bool     | Yes      | Default value: false             |
| completed_at   | date     | No       |                                  |
| image          | file     | No       | Max files: 1, Images only        |

Save the collection.

### 4. (Optional but recommended) Make it public for testing

For now, in the collection settings, under **API Rules**, set all rules to public (you can lock it down later).

### 5. Expose to the internet (Cloudflare Tunnel)

Run these commands on the Mac Mini:

```bash
# Install if not already installed
brew install cloudflare/cloudflare/cloudflared

# Login
cloudflared tunnel login

# Create tunnel
cloudflared tunnel create hazipult

# Get the tunnel ID from output, then:
cloudflared tunnel route dns <tunnel-id> hazipult.yourdomain.com

# Start the tunnel
cloudflared tunnel run --url http://localhost:8090 <tunnel-id>
```

Once the tunnel is running, your PocketBase will be available at:
`https://hazipult.yourdomain.com`

---

**Reply here with**:

- "Collection created" if you finished step 3
- Or paste any errors

After that, I will give you the updated HáziPult code so the app connects to your server and supports photo attachments.
