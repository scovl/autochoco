# autochoco
Script de Instalação Automatizada de Aplicativos via Chocolatey

Este script é destinado a automatizar a instalação de vários aplicativos em um sistema Windows utilizando o gerenciador de pacotes Chocolatey. O script verifica se o Chocolatey está instalado e, se não estiver, o instala antes de instalar os aplicativos especificados.
Requisitos

* Sistema operacional: Windows/Linux
* Acesso à Internet
* Git instalado

## Instruções de uso

1. Abra o PowerShell com privilégios de administrador.
2. Clone o repositório que contém o script e o arquivo de aplicativos no seu sistema, utilizando o seguinte comando:

```powershell
git clone https://github.com/lobocode/autochoco.git
cd autochoco
.\install-apps.ps1
```

O script irá verificar se o Chocolatey está instalado e, se não estiver, o instalará antes de instalar cada aplicativo especificado no arquivo `apps.txt`.



## Nota

* O script funciona somente em sistemas operacionais Windows.
* O script requer privilégios de administrador para executar corretamente.
* O arquivo apps.txt deve conter um nome de aplicativo por linha e estar no formato:

```powershell
gimp
inkscape
audacious
audacity
p7zip
vlc
shotcut
blender
```

* será gerado um arquivo `registro.log` onde contém tudo o que ocorreu em powershell e `error.log` para erros.

## Linux
Se você usa Linux seja Debian, Fedora ou ArchLinux, basta abrir a pasta Linux e executar os comandos abaixo:

```bash
chmod +x install-apps.sh
./install-apps.sh
```

## Nota

Observe que é necessário ter permissões de administrador (sudo) para instalar os aplicativos. Se for solicitada a senha, insira-a e pressione Enter.
