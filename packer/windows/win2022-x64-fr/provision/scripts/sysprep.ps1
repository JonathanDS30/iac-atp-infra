Write-Output "=== Running Sysprep and automatic shutdown ==="
& "$env:SystemRoot\System32\Sysprep\sysprep.exe" `
    /generalize /oobe /shutdown /quiet `
    /unattend:"C:\Program Files\Cloudbase Solutions\Cloudbase-Init\conf\Unattend.xml"