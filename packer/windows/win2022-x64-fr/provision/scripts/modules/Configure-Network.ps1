#  ---------------------------------------------------------------------------
#  Configure-Network.ps1 – Network configuration module
#  ---------------------------------------------------------------------------

$ErrorActionPreference = "Stop"

Write-Output "Configuring network settings..."

# Disable IPv6 on all network adapters
Write-Output "Disabling IPv6 on all network adapters..."
Get-NetAdapter | ForEach-Object {
    Disable-NetAdapterBinding -InterfaceAlias $_.Name -ComponentID ms_tcpip6 -Confirm:$false
}

# Enable In bound ICMPv4 traffic
Write-Output "Enabling ICMPv4 traffic..."
New-NetFirewallRule -DisplayName "ICMPv4-In" -Direction Inbound -Protocol ICMPv4 -Action Allow -Enabled True -ErrorAction SilentlyContinue

Write-Output "Network configuration completed successfully."