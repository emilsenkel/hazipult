## Recommended Deployment: GitHub Pages (Frontend on GitHub + Backend on Mac Mini)

This is the best setup for you:

- Easy to edit and version control on GitHub
- Automatic deployment when you push changes
- No need to serve the frontend from your Mac Mini
- PocketBase (backend + photos) stays on your Mac Mini via Cloudflare Tunnel

### Current Recommended Files

- `index-pocketbase.html` → This is the main app that connects to your PocketBase

### Step-by-step: Deploy to GitHub Pages

1. **Rename the file for GitHub Pages** (recommended)
   In your repo, rename `index-pocketbase.html` to `index.html` (or create a `docs` folder and put it there).

2. **Enable GitHub Pages**
   - Go to your repo: https://github.com/emilsenkel/hazipult
   - Click **Settings** → **Pages**
   - Under "Build and deployment":
     - Source: **Deploy from a branch**
     - Branch: **main**
     - Folder: **/ (root)** (or `/docs` if you put the file there)
   - Click **Save**

3. **Wait 1-2 minutes**
   Your app will be live at:
   **https://emilsenkel.github.io/hazipult/**

4. **Update the PocketBase URL in the code** (if needed)
   The file already points to `https://hazipult.chez-emil-ai.com` — this is correct.

### How the final architecture looks

- Frontend (nice UI + login): GitHub Pages (https://emilsenkel.github.io/hazipult/)
- Backend (data + photos): Your Mac Mini via Cloudflare Tunnel (https://hazipult.chez-emil-ai.com)

### Benefits
- You can edit the code directly on GitHub or from any computer
- Changes go live automatically
- Your Mac Mini only runs PocketBase (lighter load)
- Easy to give the link to the kids

Once deployed, just send the kids the GitHub Pages link, and they log in with their accounts.

Let me know when it's live and I can help with any final tweaks (prettier UI, more features, etc.).