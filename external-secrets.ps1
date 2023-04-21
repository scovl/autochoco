[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Output "Instalando aplicativos via Chocolatey"
Write-Output ""

# Verificar se o Chocolatey está instalado
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
  Write-Output "Chocolatey não está instalado. Instalando..."
  Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
  Write-Output "Chocolatey instalado com sucesso!"
  Write-Output ""
}

$defaultInstallPath = "$env:ProgramFiles"

Write-Output "Digite o caminho completo do diretorio de instalacao [pressione ENTER caso queira o caminho padrao]: "
$installPath = Read-Host

if ([string]::IsNullOrWhiteSpace($installPath)) {
  $installPath = $defaultInstallPath
}

# Ler o nome dos aplicativos do arquivo de texto
$apps = Get-Content -Path "external-secrets.txt"

# Instalar cada aplicativo
foreach ($app in $apps) {
  Write-Output "Instalando $app..."
  try {
    choco install $app -y --installargs "--install-directory=$installPath"
    Write-Output "$app instalado com sucesso." | Out-File "registro.log" -Append
  } catch {
    Write-Output "Ocorreu um erro ao instalar $app." | Out-File "error.log" -Append
  }
}

# Obter as informações de ambiente do Go
try {
  $os = go env GOOS
  $arch = go env GOARCH
} catch {
  Write-Output "Ocorreu um erro ao executar 'go env'. Verifique se o Go está instalado corretamente e configurado corretamente no PATH." | Out-File "error.log" -Append
}

# Instalar via go install
try {
  go install github.com/mikefarah/yq/v4@latest
  go install sigs.k8s.io/controller-runtime/tools/setup-envtest@latest
} catch {
  Write-Output "Ocorreu um erro ao executar 'go install'. Verifique se o Go está instalado corretamente e configurado corretamente no PATH." | Out-File "error.log" -Append
}

# Configurar o ambiente de teste do Kubernetes
try {
  setup-envtest list --os $os --arch $arch
  setup-envtest use -p path 1.20.2
  $envtestOutput = setup-envtest use 1.20.2 -p env --os $os --arch $arch
} catch {
  Write-Output "Ocorreu um erro ao executar 'setup-envtest'. Verifique se o Go está instalado corretamente e configurado corretamente no PATH." | Out-File "error.log" -Append
}

if (![string]::IsNullOrEmpty($envtestOutput)) {
    Invoke-Expression $envtestOutput
}

# descompacta zip na pasta $env:USERPROFILE\AppData\Local\kubebuilder-envtest\k8s
try {
  Expand-Archive -Path kubebuilder.zip -DestinationPath $env:USERPROFILE\AppData\Local\kubebuilder-envtest\k8s
} catch {
  Write-Output "Ocorreu um erro ao descompactar 'kubebuilder.zip'. Verifique se o arquivo existe e se você tem permissão para escrever na pasta de destino." | Out-File "error.log" -Append
}
