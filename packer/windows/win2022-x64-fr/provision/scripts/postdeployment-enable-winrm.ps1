# WinRM configuration

Write-Output "Configuring WinRM..."

# Activer WinRM si ce n'est pas déjà fait
Enable-PSRemoting -Force
winrm set winrm/config/service/auth '@{Basic="true"}'

# Vérifier s'il y a déjà un listener HTTPS
$listeners = winrm enumerate winrm/config/listener

if ($listeners -notmatch "Transport = HTTPS") {
    Write-Output "No HTTPS Listener found. Creating self-signed certificate and binding."

    # Générer un certificat auto-signé pour le nom de la machine
    $cert = New-SelfSignedCertificate -DnsName $env:COMPUTERNAME `
        -CertStoreLocation "Cert:\LocalMachine\My" `
        -KeyLength 2048 `
        -NotAfter (Get-Date).AddYears(2) `
        -FriendlyName "WinRM HTTPS Self-Signed"

    # Créer le listener HTTPS
    winrm create winrm/config/Listener?Address=*+Transport=HTTPS `
        "@{Hostname=`"$env:COMPUTERNAME`"; CertificateThumbprint=`"$($cert.Thumbprint)`"}"

    # Ouvrir le port 5986 dans le pare-feu
    New-NetFirewallRule -Name "WinRM_HTTPS" -DisplayName "WinRM HTTPS" `
        -Protocol TCP -LocalPort 5986 -Direction Inbound -Action Allow -ErrorAction SilentlyContinue

    Write-Output "WinRM HTTPS configured successfully."
} else {
    Write-Output "WinRM HTTPS listener already exists."
}

# Supprimer le listener HTTP s'il existe
$httpListener = winrm enumerate winrm/config/listener | Where-Object { $_ -match "Transport = HTTP" }
if ($httpListener) {
    winrm delete winrm/config/Listener?Address=*+Transport=HTTP
    Write-Output "HTTP WinRM listener removed."
} else {
    Write-Output "No HTTP WinRM listener found."
}

Write-Output "WinRM configuration completed."