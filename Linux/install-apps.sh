#!/bin/bash

echo "Qual é o seu sistema operacional?"
echo "1. Debian"
echo "2. Fedora"
echo "3. ArchLinux"
read -p "Selecione uma opção (1/2/3): " os

if [ $os -eq 1 ]; then
  sudo apt update
  while read app; do
    sudo apt install -y $app
  done < apps.txt
elif [ $os -eq 2 ]; then
  sudo dnf update
  while read app; do
    sudo dnf install -y $app
  done < apps.txt
elif [ $os -eq 3 ]; then
  sudo pacman -Syu
  while read app; do
    sudo pacman -S --noconfirm $app
  done < apps.txt
else
  echo "Opção inválida"
fi
