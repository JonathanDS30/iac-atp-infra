#  ---------------------------------------------------------------------------
#  setup.ps1 – Post‑install script for Windows Server 2022 template
#  Run automatically at first logon by Autounattend.xml
#  ---------------------------------------------------------------------------

$ErrorActionPreference = "Stop"        # Any non‑handled error aborts the script

Write-Output "Waiting for services to be ready..."
Start-Sleep -Seconds 5               # Give WinRM / network a few seconds to settle

# ----------------------------------------------------------------------------
# Helper – folder that contains this script and all companion binaries
# (The script is launched from a CD/floppy; using $PSScriptRoot is independent
#  of the drive letter – F:, E:, A:, etc.)
# ----------------------------------------------------------------------------
$SRC = "D:"

# ----------------------------------------------------------------------------
# 1.  Software installation
# ----------------------------------------------------------------------------
Write-Output "Installing Notepad++..."
Start-Process -FilePath "$SRC\installers\npp.8.8.1.Installer.x64.exe" -ArgumentList "/S" -Wait

# ----------------------------------------------------------------------------
# 2.  Others tweaks
# ----------------------------------------------------------------------------

# Disable IPv6 on all network adapters
Write-Output "Disabling IPv6 on all network adapters..."
Get-NetAdapter | ForEach-Object {
    Disable-NetAdapterBinding -InterfaceAlias $_.Name -ComponentID ms_tcpip6 -Confirm:$false
}

# Enable Remote Desktop
Write-Output "Enabling Remote Desktop..."
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 0

    New-NetFirewallRule -DisplayName "RDP-TCP" -Direction Inbound -Protocol TCP -LocalPort 3389 -Action Allow -Enabled True -ErrorAction SilentlyContinue
    New-NetFirewallRule -DisplayName "RDP-UDP" -Direction Inbound -Protocol UDP -LocalPort 3389 -Action Allow -Enabled True -ErrorAction SilentlyContinue

# Enable In bound ICMPv4 traffic
Write-Output "Enabling ICMPv4 traffic..."
New-NetFirewallRule -DisplayName "ICMPv4-In" -Direction Inbound -Protocol ICMPv4 -Action Allow -Enabled True -ErrorAction SilentlyContinue

# ---------------------------------------------------------------------------
# 3.  Reset autologon counter (known Sysprep issue)
# ----------------------------------------------------------------------------
Set-ItemProperty `
  -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' `
  -Name AutoLogonCount `
  -Value 0

# ----------------------------------------------------------------------------
# 4.  Cloudbase‑Init installation + configuration
# ----------------------------------------------------------------------------
Write-Output "Installing Cloudbase‑Init..."

$cloudbaseBase = 'C:\Program Files\Cloudbase Solutions\Cloudbase-Init'
$cloudbaseConf = Join-Path $cloudbaseBase 'conf'
$cloudbaseLocalScripts = Join-Path $cloudbaseBase 'LocalScripts'

# Créer le dossier LocalScripts s'il n'existe pas
if (-not (Test-Path $cloudbaseLocalScripts)) {
    New-Item -Path $cloudbaseLocalScripts -ItemType Directory -Force
}



Start-Process -FilePath "$SRC\installers\CloudbaseInitSetup_1_1_6_x64.msi" -ArgumentList "/quiet","/norestart","RUN_SERVICE_AS_LOCAL_SYSTEM=1" -Wait

Start-Sleep -Seconds 30

Copy-Item "$SRC\cloudbase-init\cloudbase-init.conf"           -Destination $cloudbaseConf -Force
Copy-Item "$SRC\cloudbase-init\cloudbase-init-unattend.conf"  -Destination $cloudbaseConf -Force
Copy-Item "$SRC\cloudbase-init\Unattend.xml"                  -Destination $cloudbaseConf -Force
Copy-Item "$SRC\postdeployment-enable-winrm.ps1" -Destination $cloudbaseLocalScripts -Force

# Wait a bit for Cloudbase-Init to settle
Start-Sleep -Seconds 10

$ErrorActionPreference = "Stop"

Write-Output "=== Starting Sysprep preparation process ==="

# Cleaning up problematic packages
Write-Output "Cleaning up problematic packages..."
try {
    Get-AppxPackage -Name Microsoft.Edge.GameAssist -ErrorAction SilentlyContinue | Remove-AppxPackage -ErrorAction SilentlyContinue
    Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like "*GameAssist*" | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue

    # Additional cleanup
    Get-AppxPackage -AllUsers | Where-Object {$_.Name -like "*Xbox*" -or $_.Name -like "*Game*"} | Remove-AppxPackage -ErrorAction SilentlyContinue

    Write-Output "Cleaning up completed successfully."
} catch {
    Write-Warning "Error during cleanup: $($_.Exception.Message)"
}

# --- Verification of Cloudbase-Init Unattend.xml
$unattendPath = "C:\Program Files\Cloudbase Solutions\Cloudbase-Init\conf\Unattend.xml"
if (-not (Test-Path $unattendPath)) {
    Write-Error "Cloudbase-Init Unattend.xml file not found at: $unattendPath"
    exit 1
}

Write-Output "Cloudbase-Init configured correctly."
Start-Sleep -Seconds 5

# ----------------------------------------------------------------------------
# 5.  Sysprep and automatic shutdown
# ----------------------------------------------------------------------------

Write-Output "Launching Sysprep script..."
& "$SRC\sysprep.ps1"
