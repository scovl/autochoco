[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Output "Installing applications via Chocolatey"
Write-Output ""

# Check if Chocolatey is installed
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
  Write-Output "Chocolatey is not installed. Installing..."
  Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
  Write-Output "Chocolatey installed successfully!"
  Write-Output ""
}

$defaultInstallPath = "$env:ProgramFiles"

Write-Output "Enter the full installation directory path [press ENTER for default path]: "
$installPath = Read-Host

if ([string]::IsNullOrWhiteSpace($installPath)) {
  $installPath = $defaultInstallPath
}

# Read the application names from a text file
$apps = Get-Content -Path "external-secrets.txt"

# Install each application
foreach ($app in $apps) {
  Write-Output "Installing $app..."
  try {
    choco install $app -y --installargs "--install-directory=$installPath"
    Write-Output "$app installed successfully." | Out-File "registro.log" -Append
  } catch {
    Write-Output "An error occurred while installing $app." | Out-File "error.log" -Append
  }
}

# Get Go environment information
try {
  $os = go env GOOS
  $arch = go env GOARCH
} catch {
  Write-Output "An error occurred while executing 'go env'. Please check that Go is installed correctly and configured correctly in the PATH variable." | Out-File "error.log" -Append
}

# Install via go install
try {
  go install github.com/mikefarah/yq/v4@latest
  go install sigs.k8s.io/controller-runtime/tools/setup-envtest@latest
} catch {
  Write-Output "An error occurred while executing 'go install'. Please check that Go is installed correctly and configured correctly in the PATH variable." | Out-File "error.log" -Append
}

# Configure the Kubernetes test environment
try {
  setup-envtest list --os $os --arch $arch
  setup-envtest use -p path 1.20.2
  $envtestOutput = setup-envtest use 1.20.2 -p env --os $os --arch $arch
} catch {
  Write-Output "An error occurred while executing 'setup-envtest'. Please check that Go is installed correctly and configured correctly in the PATH variable." | Out-File "error.log" -Append
}

if (![string]::IsNullOrEmpty($envtestOutput)) {
    Invoke-Expression $envtestOutput
}

# Unzip a file to the directory $env:USERPROFILE\AppData\Local\kubebuilder-envtest\k8s
try {
  Expand-Archive -Path ../kubebuilder.zip -DestinationPath $env:USERPROFILE\AppData\Local\kubebuilder-envtest\k8s
} catch {
  Write-Output "An error occurred while unzipping 'kubebuilder.zip'. Please check that the file exists and that you have permission to write to the destination folder." | Out-File "error.log" -Append
}

# Define the path to be added
$PathToAdd = "$env:USERPROFILE\AppData\Local\kubebuilder-envtest\k8s"

# Check if the path already exists in the system Path
if ([Environment]::GetEnvironmentVariable("Path", "Machine") -notlike "*$PathToAdd*") {
    # Add the path to the System Path
    $CurrentValue = [Environment]::GetEnvironmentVariable("Path", "Machine")
    $NewValue = "$CurrentValue;$PathToAdd"
    [Environment]::SetEnvironmentVariable("Path", $NewValue, "Machine")

    # Update the System Path to the current PowerShell
    $env:Path = [Environment]::GetEnvironmentVariable("Path", "User") + ";" + $NewValue
}

$response = Read-Host "An operation requires a restart. Do you want to restart now? (Y/N)"
if ($response -eq "Y" -or $response -eq "y") {
    Restart-Computer -Force
} else {
    Write-Host "The operation cannot be completed without restarting Windows. Please consider restarting your computer soon."
}