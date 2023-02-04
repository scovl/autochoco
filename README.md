# Autochoco
Script de Instalação Automatizada de Aplicativos via Chocolatey

Este script é destinado a automatizar a instalação de vários aplicativos em um sistema Windows utilizando o gerenciador de pacotes Chocolatey. O script verifica se o Chocolatey está instalado e, se não estiver, o instala antes de instalar os aplicativos especificados.


## Requisitos

É necessário a execução de scripts PowerShell e, portanto você precisa usar o cmdlet Set-ExecutionPolicy:

* Sistema operacional: Microsoft Windows (qualquer versão)
* Acesso à Internet
* Git instalado

**NOTA**: Se não tiver o git instalado, baixe o zip do repositório **[AQUI](https://github.com/lobocode/autochoco/archive/refs/heads/main.zip)**, descompacte em uma pasta e siga as instruções abaixo. 

## Instruções de uso

1. Abra o PowerShell com privilégios de administrador, e digite os comandos a seguir:
```powershell 
git clone https://github.com/lobocode/autochoco.git
cd autochoco

# Após entrar na pasta autochoco e edite o arquivo de apps.txt com as ferramentas/aplicações que deseja instalar
# Por fim digite o comando abaixo para executar o programa:
powershell.exe -ExecutionPolicy Bypass -File .\install-apps.ps1

```

**NOTA**: O comando `powershell.exe -ExecutionPolicy Bypass -File .\install-apps.ps1` é usado para executar um script PowerShell `install-apps.ps1` com a política de execução "Bypass". Desta forma seu sistema executa o script sem modificar a política padrão de segurança restrita. Por fim, o script irá verificar se o Chocolatey está instalado e, se não estiver, o instalará antes de instalar cada aplicativo especificado no arquivo `apps.txt`.


## Nota

* O script funciona somente em sistemas operacionais Windows.
* O script requer privilégios de administrador para executar corretamente.
* O arquivo apps.txt deve conter um nome de aplicativo por linha e estar no formato:

```powershell
gimp
inkscape
audacious
audacity
7zip
vlc
shotcut
blender
python37
notepadplusplus.install
vscode
intellijidea-community
firefox
googlechrome
```

* Será gerado um arquivo `registro.log` onde contém tudo o que ocorreu em powershell e `error.log` para erros.

## Linux
Se você usa Linux seja Debian, Fedora ou ArchLinux, basta abrir a pasta Linux e executar os comandos abaixo:

```bash
chmod +x install-apps.sh
./install-apps.sh
```

## Nota

Observe que é necessário ter permissões de administrador (sudo) para instalar os aplicativos. Se for solicitada a senha, insira-a e pressione Enter.

