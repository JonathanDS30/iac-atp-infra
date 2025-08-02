#  ---------------------------------------------------------------------------
#  Cleanup-Apps.ps1 – Prepare the system by removing unwanted applications
#  and packages that may interfere with during the sysprep.
#  ---------------------------------------------------------------------------

$ErrorActionPreference = "Stop"

Write-Output "Starting application cleanup..."

try {
    # Cleaning up problematic packages
    Get-AppxPackage -Name Microsoft.Edge.GameAssist -ErrorAction SilentlyContinue | Remove-AppxPackage -ErrorAction SilentlyContinue
    Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like "*GameAssist*" | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue

    # Additional cleanup
    Get-AppxPackage -AllUsers | Where-Object {$_.Name -like "*Xbox*" -or $_.Name -like "*Game*"} | Remove-AppxPackage -ErrorAction SilentlyContinue

    Write-Output "Application cleanup completed successfully."
} catch {
    Write-Warning "Error during cleanup: $($_.Exception.Message)"
    throw
}