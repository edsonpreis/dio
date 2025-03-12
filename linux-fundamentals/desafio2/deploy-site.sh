#!/bin/bash

# Definição do snapshot (substitua 'meu_snapshot' pelo nome real)
SNAPSHOT_NAME="meu_snapshot"
VM_NAME="minha_vm"

# Restaurando snapshot no VirtualBox
echo "Restaurando snapshot no VirtualBox..."
VBoxManage controlvm "$VM_NAME" poweroff
VBoxManage snapshot "$VM_NAME" restore "$SNAPSHOT_NAME"
VBoxManage startvm "$VM_NAME" --type headless
sleep 10  # Aguarda a VM inicializar

# Atualizando o servidor
echo "Atualizando o servidor..."
sudo apt update -y && sudo apt upgrade -y

# Instalando Apache e Unzip
echo "Instalando Apache e Unzip..."
sudo apt install apache2 unzip -y

# Baixando a aplicação
echo "Baixando a aplicação..."
cd /tmp
wget https://github.com/denilsonbonatti/linux-site-dio/archive/refs/heads/main.zip

# Extraindo a aplicação
echo "Extraindo os arquivos..."
unzip main.zip

# Copiando os arquivos para o Apache
echo "Copiando arquivos para o diretório padrão do Apache..."
sudo cp -R linux-site-dio-main/* /var/www/html/

# Ajustando permissões
echo "Ajustando permissões..."
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/

# Reiniciando o Apache
echo "Reiniciando o Apache..."
sudo systemctl restart apache2

echo "Provisionamento finalizado com sucesso!"
