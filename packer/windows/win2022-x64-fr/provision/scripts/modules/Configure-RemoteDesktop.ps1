#  ---------------------------------------------------------------------------
#  Configure-RemoteDesktop.ps1 – Remote Desktop configuration module
#  ---------------------------------------------------------------------------

$ErrorActionPreference = "Stop"

Write-Output "Configuring Remote Desktop..."

# Enable Remote Desktop
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 0

# Configure firewall rules for RDP
New-NetFirewallRule -DisplayName "RDP-TCP" -Direction Inbound -Protocol TCP -LocalPort 3389 -Action Allow -Enabled True -ErrorAction SilentlyContinue
New-NetFirewallRule -DisplayName "RDP-UDP" -Direction Inbound -Protocol UDP -LocalPort 3389 -Action Allow -Enabled True -ErrorAction SilentlyContinue

Write-Output "Remote Desktop configured successfully."