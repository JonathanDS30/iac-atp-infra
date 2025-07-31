# ---------------------------
# WinRM configuration 
# ---------------------------

Write-Output "Configuring WinRM..."
Enable-PSRemoting -Force
winrm set winrm/config/service/auth '@{Basic="true"}'

# Ensure an HTTPS listener exists; if not, create one + firewall rule
$hasHttps = (winrm enumerate winrm/config/listener) -match "Transport = HTTPS"
if (-not $hasHttps) {
    Write-Output "Creating HTTPS listener with a self‑signed certificate…"

    $cert = New-SelfSignedCertificate `
                -DnsName $env:COMPUTERNAME `
                -CertStoreLocation "Cert:\LocalMachine\My" `
                -KeyLength 2048 `
                -NotAfter (Get-Date).AddYears(2) `
                -FriendlyName "WinRM‑HTTPS Self‑Signed"

    winrm create winrm/config/Listener?Address=*+Transport=HTTPS `
        "@{Hostname=`"$env:COMPUTERNAME`";CertificateThumbprint=`"$($cert.Thumbprint)`"}"

    New-NetFirewallRule -Name "WinRM_HTTPS" -DisplayName "WinRM HTTPS" `
        -Protocol TCP -LocalPort 5986 -Direction Inbound -Action Allow
}

# Remove the insecure HTTP listener, if present
if ((winrm enumerate winrm/config/listener) -match "Transport = HTTP") {
    Write-Output "Removing HTTP WinRM listener…"
    winrm delete winrm/config/Listener?Address=*+Transport=HTTP
}