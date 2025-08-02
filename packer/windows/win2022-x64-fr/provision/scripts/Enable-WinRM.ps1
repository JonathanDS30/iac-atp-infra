#  ---------------------------------------------------------------------------
#  Enable-WinRM.ps1 – Enable WinRM for remote management
#  ---------------------------------------------------------------------------

Write-Output "Configuring WinRM..."

# Enable Remote Management 
Enable-PSRemoting -Force
winrm set winrm/config/service/auth '@{Basic="true"}'

# Check if there is already an HTTPS listener
$listeners = winrm enumerate winrm/config/listener

if ($listeners -notmatch "Transport = HTTPS") {
    Write-Output "No HTTPS Listener found. Creating self-signed certificate and binding."

    # Generate a self-signed certificate for the machine name
    $cert = New-SelfSignedCertificate -DnsName $env:COMPUTERNAME `
        -CertStoreLocation "Cert:\LocalMachine\My" `
        -KeyLength 2048 `
        -NotAfter (Get-Date).AddYears(2) `
        -FriendlyName "WinRM HTTPS Self-Signed"

    # Create the HTTPS listener
    winrm create winrm/config/Listener?Address=*+Transport=HTTPS `
        "@{Hostname=`"$env:COMPUTERNAME`"; CertificateThumbprint=`"$($cert.Thumbprint)`"}"

    # Open port 5986 in the firewall
    New-NetFirewallRule -Name "WinRM_HTTPS" -DisplayName "WinRM HTTPS" `
        -Protocol TCP -LocalPort 5986 -Direction Inbound -Action Allow -ErrorAction SilentlyContinue

    Write-Output "WinRM HTTPS configured successfully."
} else {
    Write-Output "WinRM HTTPS listener already exists."
}

# Remove the HTTP listener if it exists
$httpListener = winrm enumerate winrm/config/listener | Where-Object { $_ -match "Transport = HTTP" }
if ($httpListener) {
    winrm delete winrm/config/Listener?Address=*+Transport=HTTP
    Write-Output "HTTP WinRM listener removed."
} else {
    Write-Output "No HTTP WinRM listener found."
}

Write-Output "WinRM configuration completed."