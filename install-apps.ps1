Write-Output "Instalando aplicativos via Chocolatey"
Write-Output ""

# Verificar se o Chocolatey está instalado
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
  Write-Output "Chocolatey não está instalado. Instalando..."
  Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
  Write-Output "Chocolatey instalado com sucesso!"
  Write-Output ""
}

# Ler o nome dos aplicativos do arquivo de texto
$apps = Get-Content -Path "apps.txt"

# Instalar cada aplicativo
foreach ($app in $apps) {
  Write-Output "Instalando $app"
  choco install $app -y
  Write-Output ""
}

Write-Output "Todos os aplicativos foram instalados com sucesso!"
