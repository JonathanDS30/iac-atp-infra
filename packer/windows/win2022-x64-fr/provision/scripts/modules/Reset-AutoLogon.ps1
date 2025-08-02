#  ---------------------------------------------------------------------------
#  Reset-AutoLogon.ps1 – Reset autologon counter module
#  ---------------------------------------------------------------------------

$ErrorActionPreference = "Stop"

Write-Output "Resetting autologon counter..."

# Reset autologon counter (known Sysprep issue)
Set-ItemProperty `
  -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' `
  -Name AutoLogonCount `
  -Value 0

Write-Output "Autologon counter reset successfully."