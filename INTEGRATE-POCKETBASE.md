## Full Integration + Multi-Kid Login (In Progress)

**Goal:** Turn HáziPult into a real multi-user cloud app using your PocketBase.

### What will be built
- Login screen (kids can log in with their own account)
- Full data sync with PocketBase (everything saved in the cloud automatically)
- Photo attachments for homework tasks
- Each kid only sees their own tasks
- Simple and kid-friendly interface

### Current Progress
- `index-pocketbase.html` created as the new working version
- PocketBase client initialized
- Basic connection to `https://hazipult.chez-emil-ai.com` confirmed

### Next Steps (being executed now)
1. Add proper authentication (login/register for multiple kids)
2. Replace all localStorage logic with PocketBase
3. Add photo upload + display
4. Polish the UI for multi-user use

I am now starting to build the full version.

You can follow progress by checking the commits on `index-pocketbase.html`.

Once ready, we will replace or rename it to become the main app.