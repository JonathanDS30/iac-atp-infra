#  ---------------------------------------------------------------------------
#  Install-CloudbaseInit.ps1 – Cloudbase-Init installation module
#  ---------------------------------------------------------------------------

param(
    [Parameter(Mandatory=$true)]
    [string]$Version,
    
    [Parameter(Mandatory=$true)]
    [string]$SourcePath
)

$ErrorActionPreference = "Stop"

Write-Output "Installing Cloudbase-Init v$Version..."
Write-Output "Using source path: $SourcePath"

$versionUnderscore = $Version.replace(".","_")
$cloudbaseUrl = "https://github.com/cloudbase/cloudbase-init/releases/download/${Version}/CloudbaseInitSetup_${versionUnderscore}_x64.msi"
$cloudbaseInstaller = "$env:TEMP\CloudbaseInitSetup_${versionUnderscore}_x64.msi"

try {
    # Download the Cloudbase-Init installer
    Write-Output "Downloading Cloudbase-Init from $cloudbaseUrl..."
    Invoke-WebRequest -Uri $cloudbaseUrl -OutFile $cloudbaseInstaller -UseBasicParsing
    Write-Output "Download completed successfully."

    # Verification
    if (-not (Test-Path $cloudbaseInstaller)) {
        throw "Cloudbase-Init installer not found at: $cloudbaseInstaller"
    }
    
    # Install Cloudbase-Init
    Write-Output "Installing Cloudbase-Init..."
    Start-Process -FilePath $cloudbaseInstaller -ArgumentList "/quiet","/norestart","RUN_SERVICE_AS_LOCAL_SYSTEM=1" -Wait

    # Cleanup the temporary file
    Remove-Item $cloudbaseInstaller -Force -ErrorAction SilentlyContinue
    
    # Files paths for the configuration of cloudbase-init
    $cloudbaseBase = 'C:\Program Files\Cloudbase Solutions\Cloudbase-Init'
    $cloudbaseConf = Join-Path $cloudbaseBase 'conf'
    $cloudbaseLocalScripts = Join-Path $cloudbaseBase 'LocalScripts'
    
    if (-not (Test-Path $cloudbaseLocalScripts)) {
        New-Item -Path $cloudbaseLocalScripts -ItemType Directory -Force
    }
    
    Start-Sleep -Seconds 30

    # Copy configuration files from the SourcePath
    Copy-Item "$SourcePath\cloudbase-init\cloudbase-init.conf" -Destination $cloudbaseConf -Force
    Copy-Item "$SourcePath\cloudbase-init\cloudbase-init-unattend.conf" -Destination $cloudbaseConf -Force
    Copy-Item "$SourcePath\cloudbase-init\Unattend.xml" -Destination $cloudbaseConf -Force
    Copy-Item "$SourcePath\Enable-WinRM.ps1" -Destination $cloudbaseLocalScripts -Force
    
    Write-Output "Cloudbase-Init v$Version installed and configured successfully."
    
} catch {
    Write-Error "Failed to install Cloudbase-Init: $($_.Exception.Message)"
    throw
}