#  ---------------------------------------------------------------------------
#  setup.ps1 – Post‑install script for Windows Server 2022 template
#  ---------------------------------------------------------------------------

$ErrorActionPreference = "Stop"        # Any non‑handled error aborts the script

Write-Output "Waiting for services to be ready..."
Start-Sleep -Seconds 5               # Give WinRM / network a few seconds to settle

# ----------------------------------------------------------------------------
#  Set the source directory for the script & software versions
# ----------------------------------------------------------------------------

# Find other scripts and files
$SRC = "D:"

# Software versions
$cloudbaseInitVersion = "1.1.6"
$notepadVersion = "8.8.3"

Write-Output "=== Starting Windows Server 2022 template setup ==="


    Write-Output "=== Phase 1: Software Installation ==="
    & "$SRC\Install-Notepad.ps1" -Version $notepadVersion
    & "$SRC\Install-CloudbaseInit.ps1" -Version $cloudbaseInitVersion -SourcePath $SRC
    
    Write-Output "=== Phase 2: System Configuration ==="
    & "$SRC\Configure-Network.ps1"
    & "$SRC\Configure-RemoteDesktop.ps1"
    
    Write-Output "=== Phase 3: System Preparation ==="
    & "$SRC\Reset-AutoLogon.ps1"
    & "$SRC\Cleanup-Apps.ps1"
    
    Write-Output "=== Phase 4: Final Verification ==="
    # Verification of Cloudbase-Init Unattend.xml
    $unattendPath = "C:\Program Files\Cloudbase Solutions\Cloudbase-Init\conf\Unattend.xml"
    if (-not (Test-Path $unattendPath)) {
        Write-Error "Cloudbase-Init Unattend.xml file not found at: $unattendPath"
        exit 1
    }
    Write-Output "Cloudbase-Init configured correctly."
    Start-Sleep -Seconds 5
    
    Write-Output "=== Phase 5: Sysprep ==="
    & "$SRC\Run-Sysprep.ps1"