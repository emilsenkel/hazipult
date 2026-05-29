## Cloudflare Tunnel Setup (After you created the collection manually)

Your PocketBase is running locally. To make it accessible from anywhere (phone at school, etc.), we need to expose it safely.

### 1. Install cloudflared (if not already installed)

```bash
brew install cloudflare/cloudflare/cloudflared
```

### 2. Login to Cloudflare

```bash
cloudflared tunnel login
```

This will open a browser — log in with your Cloudflare account.

### 3. Create the tunnel

```bash
cloudflared tunnel create hazipult
```

Copy the **Tunnel ID** from the output (it looks like a long string of letters/numbers).

### 4. Create a DNS record (choose one)

**Option A — If you have your own domain** (recommended):
Replace `yourdomain.com` with your actual domain.

```bash
cloudflared tunnel route dns <YOUR-TUNNEL-ID> hazipult.yourdomain.com
```

**Option B — Free temporary URL** (no domain needed):
Skip this step for now and use the URL from the next command.

### 5. Start the tunnel

```bash
cloudflared tunnel run --url http://localhost:8090 <YOUR-TUNNEL-ID>
```

Leave this terminal window open (or run it in screen/tmux).

You will get a public URL like:
- `https://hazipult.yourdomain.com` (if you used Option A)
- or a temporary `https://something.trycloudflare.com`

### 6. Test it

From your phone or another computer, open:
`https://your-public-url/_/`

You should see the PocketBase login page.

---

**Once you have a working public URL**, reply here with it (example: `https://hazipult.myhouse.com` or the trycloudflare one).

I will then update the HáziPult app code so it connects to your server, saves everything in the cloud automatically, and supports uploading photos for each homework task.