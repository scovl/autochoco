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

# Instalar via go install
go install github.com/mikefarah/yq/v4@latest
go install sigs.k8s.io/controller-runtime/tools/setup-envtest@latest


$os = go env GOOS
$arch = go env GOARCH

setup-envtest list --os $os --arch $arch
setup-envtest use -p path 1.20.2

$envtestOutput = setup-envtest use 1.20.2 -p env --os $os --arch $arch


if (![string]::IsNullOrEmpty($envtestOutput)) {
    Invoke-Expression $envtestOutput
}

# Clonar o repositório do GitHub
git clone git@github.com:kubernetes-sigs/kubebuilder

# Acessar o diretório clonado
cd kubebuilder

# Compilar o binário do kubebuilder
go build -o kubebuilder.exe ./cmd/

# Executar o kubebuilder.exe e exibir o código completo
./kubebuilder.exe -e | Out-String

# Move o kubebuilder.exe para um diretório no PATH e remove o diretório kubebuilder
Move-Item -Path kubebuilder.exe -Destination $env:USERPROFILE\bin
Remove-Item -Path kubebuilder -Recurse


helm plugin install https://github.com/helm-unittest/helm-unittest

Write-Output "`nTodos os aplicativos foram instalados com sucesso!"```