# PowerShell Script to Create Initial Config File Structure
$envs = 'dev', 'qa', 'uat', 'prod'
$services = 'WEB', 'DATABASE', 'COMMON', 'API', 'ADMIN-PANEL'

foreach ($env in $envs) {
    $dirPath = Join-Path -Path "./configs" -ChildPath $env
    New-Item -ItemType Directory -Force -Path $dirPath
    foreach ($service in $services) {
        $fileName = "service-$service-configs.txt"
        $filePath = Join-Path -Path $dirPath -ChildPath $fileName
        New-Item -ItemType File -Force -Path $filePath
    }
}
