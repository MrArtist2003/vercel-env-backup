# Quick Vercel Env Backup for Windows Devs

Tired of manually pulling env vars in Vercel CLI? This simple script automates it:
- Downloads your dev env vars to a temp file.
- Cleans up automatically.
- Works with Vercel CLI v33.6.0+ (local network backup).

## How to Use
1. Download `vercel-backup.bat` from this repo.
2. Open Command Prompt in your Vercel-linked project folder (e.g., `cd C:\my-app`).
3. Run: `vercel-backup.bat` (or double-click it).
4. Done! It says "Backup complete."

**Note**: Requires Vercel CLI installed (`npm i -g vercel`). Test on a dummy project. (Assumes local network for backup.)

Happy deploying! 🚀
