#!/bin/bash

# HáziPult - PocketBase + Cloudflare Tunnel Setup for Mac Mini
# Run this on your Mac Mini

set -e

echo "🚀 Starting HáziPult server setup on Mac Mini..."

# 1. Create PocketBase folder
mkdir -p ~/pocketbase
cd ~/pocketbase

echo "📥 Downloading PocketBase..."

# Download latest PocketBase for Apple Silicon (change to amd64 if Intel)
if [[ $(uname -m) == 'arm64' ]]; then
    curl -L https://github.com/pocketbase/pocketbase/releases/download/v0.22.20/pocketbase_0.22.20_darwin_arm64.zip -o pb.zip
else
    curl -L https://github.com/pocketbase/pocketbase/releases/download/v0.22.20/pocketbase_0.22.20_darwin_amd64.zip -o pb.zip
fi

unzip -o pb.zip
chmod +x pocketbase
rm -f pb.zip

echo "✅ PocketBase downloaded."

# 2. Create a simple launch script
cat > start-pocketbase.sh << 'EOF'
#!/bin/bash
cd ~/pocketbase
nohup ./pocketbase serve > pocketbase.log 2>&1 &
echo $! > pocketbase.pid
echo "PocketBase started (PID: $(cat pocketbase.pid))"
EOF

chmod +x start-pocketbase.sh

# 3. Start PocketBase
./start-pocketbase.sh

sleep 3

echo "
✅ PocketBase is now running at http://localhost:8090"
echo "Open http://localhost:8090/_/ in your browser to create the admin account."

echo "
Next steps:"
echo "1. Create admin account in the browser"
echo "2. Create the 'assignments' collection (see SETUP-POCKETBASE.md)"
echo "3. Run the Cloudflare Tunnel setup below"

echo "
To stop PocketBase later: kill \\\$(cat ~/pocketbase/pocketbase.pid)"

echo "
--- Cloudflare Tunnel Setup ---"
echo "Run these commands next:"
echo "brew install cloudflare/cloudflare/cloudflared"
echo "cloudflared tunnel login"
echo "cloudflared tunnel create hazipult"
echo "# Then route DNS and run the tunnel pointing to localhost:8090"
