## Step 3: Make Your PocketBase Publicly Accessible (From Anywhere)

Great job! You've finished setting up the `assignments` collection.

Now we need to make PocketBase reachable from the internet so the HáziPult app can save data in the cloud and the 13-year-old can use it from school, phone, etc.

### Recommended: Use Cloudflare Tunnel (Free & Secure)

Run these commands on your Mac Mini:

```bash
# 1. Install cloudflared if you don't have it
brew install cloudflare/cloudflare/cloudflared

# 2. Login to Cloudflare
cloudflared tunnel login

# 3. Create a tunnel
cloudflared tunnel create hazipult

# Copy the Tunnel ID from the output (it will be a long string)

# 4. Create a public address (choose one option)

# Option A - With your own domain (recommended)
cloudflared tunnel route dns <YOUR-TUNNEL-ID> hazipult.yourdomain.com

# Option B - Free temporary URL (no domain needed)
# Skip this step if using Option A

# 5. Start the tunnel (run this command)
cloudflared tunnel run --url http://localhost:8090 <YOUR-TUNNEL-ID>
```

Leave this command running (you can use `screen` or `tmux` if you want to detach).

You will now have a public URL, for example:
- `https://hazipult.yourdomain.com`
- or `https://random-words.trycloudflare.com`

### Test it

From your phone or another computer, open:
`https://your-public-url/_/`

You should see the PocketBase admin login page.

---

**Once you have a working public URL**, reply here with it.

Example:
> My public URL is: https://hazipult.myhouse.com

I will then update the HáziPult app code so it connects to your server, saves everything automatically in the cloud, and supports uploading photos for homework tasks.