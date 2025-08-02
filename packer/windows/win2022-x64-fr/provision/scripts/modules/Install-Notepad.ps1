#  ---------------------------------------------------------------------------
#  Install-Notepad.ps1 – Notepad++ installation module
#  ---------------------------------------------------------------------------

param(
    [Parameter(Mandatory=$true)]
    [string]$Version
)

$ErrorActionPreference = "Stop"

Write-Output "Installing Notepad++ v$Version..."

$notepadUrl = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v${Version}/npp.${Version}.Installer.x64.exe"
$notepadInstaller = "$env:TEMP\npp.${Version}.Installer.x64.exe"

try {
    Write-Output "Downloading Notepad++ from $notepadUrl..."
    Invoke-WebRequest -Uri $notepadUrl -OutFile $notepadInstaller -UseBasicParsing
    Write-Output "Download completed successfully."
    
    # Vérification du téléchargement
    if (-not (Test-Path $notepadInstaller)) {
        throw "Notepad++ installer not found at: $notepadInstaller"
    }
    
    # Installation
    Write-Output "Installing Notepad++..."
    Start-Process -FilePath $notepadInstaller -ArgumentList "/S" -Wait
    
    # Nettoyage
    Remove-Item $notepadInstaller -Force -ErrorAction SilentlyContinue
    
    Write-Output "Notepad++ v$Version installed successfully."
    
} catch {
    Write-Error "Failed to install Notepad++: $($_.Exception.Message)"
    throw
}