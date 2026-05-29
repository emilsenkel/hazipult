## Free Domain Options for Your Cloudflare Tunnel

You have your Tunnel ID: `81d8bc90-2ee3-4c73-b40a-047c24ee7fd2`

### Does GitHub offer a free domain?

**No.** GitHub does **not** provide free domains or subdomains you can use to expose a local server like PocketBase.

GitHub Pages only gives you `yourusername.github.io` for hosting static websites, not for proxying to your Mac Mini.

### Best Free Option Right Now: trycloudflare.com (Recommended)

Cloudflare gives you a free temporary public URL automatically. No registration needed.

Run this command on your Mac Mini:

```bash
cloudflared tunnel run 81d8bc90-2ee3-4c73-b40a-047c24ee7fd2
```

After a few seconds, you should see something like this in the output:

```
2026-05-30T... INF | https://random-words-1234.trycloudflare.com
```

That `https://...trycloudflare.com` link is your free public URL.

You can use it immediately in the HáziPult app.

### Other Free Options (if you want something more permanent)

1. **DuckDNS** (free)
   - Get a subdomain like `yourname.duckdns.org`
   - Requires a bit more setup

2. **No-IP** (free tier)
   - Similar to DuckDNS

3. **Cloudflare Registrar** (paid domains)
   - If you buy a cheap domain later

### What to do now

1. Run the command above.
2. Copy the `https://...trycloudflare.com` URL it gives you.
3. Reply here with that URL.

Example reply:
> My public URL is: https://happy-cat-4721.trycloudflare.com

Once I have the URL, I will update the HáziPult app so it connects to your PocketBase and supports photo uploads.