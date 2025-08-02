#  ---------------------------------------------------------------------------
#  Run-Sysprep.ps1 – Run Sysprep and automatic shutdown module
#  ---------------------------------------------------------------------------

Write-Output "Running Sysprep..."
& "$env:SystemRoot\System32\Sysprep\sysprep.exe" `
    /generalize /oobe /shutdown /quiet `
    /unattend:"C:\Program Files\Cloudbase Solutions\Cloudbase-Init\conf\Unattend.xml"