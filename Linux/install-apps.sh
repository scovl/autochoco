#!/bin/bash

echo "Qual é o seu sistema operacional?"
echo "1. Debian"
echo "2. Fedora"
echo "3. ArchLinux"
read -p "Selecione uma opção (1/2/3): " os

echo "Insira sua senha de administrador (sudo)"
read -s password
echo

if [ $os -eq 1 ]; then
  echo $password | sudo -S apt update
  while read app; do
    echo $password | sudo -S apt install -y $app
  done < apps.txt
elif [ $os -eq 2 ]; then
  echo $password | sudo -S dnf update
  while read app; do
    echo $password | sudo -S dnf install -y $app
  done < apps.txt
elif [ $os -eq 3 ]; then
  echo $password | sudo -S pacman -Syu
  while read app; do
    echo $password | sudo -S pacman -S --noconfirm $app
  done < apps.txt
else
  echo "Opção inválida"
fi
