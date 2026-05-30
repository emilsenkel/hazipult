## Diagnose Your Existing Cloudflare Setup

Run these commands on your Mac Mini and paste the full output here.

```bash
# 1. Check which cloudflared processes are currently running
echo "=== Running cloudflared processes ==="
ps aux | grep -v grep | grep -i cloudflared

# 2. Show the contents of the .cloudflared folder
echo "
=== Files in ~/.cloudflared ==="
ls -la ~/.cloudflared/

# 3. Show the main config file (most important!)
echo "
=== Main config.yml (if exists) ==="
cat ~/.cloudflared/config.yml 2>/dev/null || cat ~/.cloudflared/config.yaml 2>/dev/null || echo "No config.yml or config.yaml found"

# 4. List all tunnel credential files
echo "
=== Tunnel credential files ==="
ls -la ~/.cloudflared/*.json 2>/dev/null || echo "No .json credential files found"

# 5. Check for LaunchAgents / Daemons (persistent services)
echo "
=== LaunchAgents (user level) ==="
ls -la ~/Library/LaunchAgents/ 2>/dev/null | grep -i cloudflared || echo "None found"

echo "
=== LaunchDaemons (system level) ==="
ls -la /Library/LaunchDaemons/ 2>/dev/null | grep -i cloudflared || echo "None found"

# 6. Show recent cloudflared logs (if any)
echo "
=== Recent cloudflared logs (if any) ==="
log show --predicate 'process == "cloudflared"' --last 10m 2>/dev/null | tail -30 || echo "No logs found via log show"
```

Paste everything that gets printed. This will let me see exactly how your existing production Cloudflare Tunnels are configured so we can safely add HáziPult without breaking your other services.