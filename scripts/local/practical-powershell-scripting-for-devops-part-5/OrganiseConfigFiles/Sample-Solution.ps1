[CmdletBinding()]
# Define paths
param(
    [string]$rootPath = "./configs",
    [string]$targetPath = "./organised-configs"
)

# Function to log messages
function Out-Log {
    param([string]$Message)
    Write-Host "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'): $Message"
}

# Create the target directory if it doesn't exist
try {
    if (-not (Test-Path $targetPath)) {
        New-Item -Path $targetPath -ItemType Directory | Out-Null
        Out-Log "Created target directory at $targetPath"
    }
} catch {
    Out-Log "Error creating target directory: $_"
}

# Process each environment folder
Get-ChildItem -Path $rootPath -Directory | ForEach-Object {
    $env = $_.Name.ToUpper()
    $newEnvPath = Join-Path -Path $targetPath -ChildPath $env
    
    try {
        New-Item -Path $newEnvPath -ItemType Directory -Force | Out-Null
        Out-Log "Created new environment folder: $env"
    } catch {
        Out-Log "Error creating environment folder $($env): $_"
        continue
    }

    # $_ is shorthand form of $PSItem variable, wanted to show you usage of both
    Get-ChildItem -Path $PSItem.FullName -File | ForEach-Object {
        $serviceName = $_.BaseName -replace 'service-', '' -replace '-configs', ''
        $newFileName = "$($env)_service_$($serviceName.ToLower().Replace('-','_'))_configs.zip"
        $newFilePath = Join-Path -Path $newEnvPath -ChildPath $newFileName

        try {
            Compress-Archive -Path $_.FullName -DestinationPath $newFilePath -Force
            Out-Log "Archived file: $newFileName"
        } catch {
            Out-Log "Error archiving file $($_): $_"
        }
    }
}
