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

# Instalar via go isntall
go install go install github.com/mikefarah/yq/v4@latest
go install sigs.k8s.io/controller-runtime/tools/setup-envtest@latest

setup-envtest list --os $(go env GOOS) --arch $(go env GOARCH)
setup-envtest use -p path 1.20.3

source <(setup-envtest use 1.20.3 -p env --os $(go env GOOS) --arch $(go env GOARCH))

helm plugin install https://github.com/helm-unittest/helm-unittest

Write-Output "Todos os aplicativos foram instalados com sucesso!"