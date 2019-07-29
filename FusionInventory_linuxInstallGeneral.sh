# Instalação do Fusion Inventory em distribuições Linux baseadas em Debian
# Version: 2.0
# Última alteração: 29/07/2019 - 15:15 BRT
# Criador: Hallison F. da Silva
# Alterado por:


#!/bin/bash

# Acessa a home do usuário
cd ~

# Instala as dependências
apt -y install dmidecode hwdata ucf hdparm
apt -y install perl libuniversal-require-perl libwww-perl libparse-edid-perl
apt -y install libproc-daemon-perl libfile-which-perl libhttp-daemon-perl
apt -y install libxml-treepp-perl libyaml-perl libnet-cups-perl libnet-ip-perl
apt -y install libdigest-sha-perl libsocket-getaddrinfo-perl libtext-template-perl
apt -y install libxml-xpath-perl

# Faz download do pacote FusionInventory
wget https://github.com/fusioninventory/fusioninventory-agent/releases/download/2.5.1/fusioninventory-agent_2.5.1-1_all.deb

# Instala o pacote 
dpkg -i fusioninventory-agent_2.5.1-1_all.deb

# Substitui o parâmetro do servidor executando o FusionInventory
read -p "Enter FusionInventory server URI: http://" uriServer

# Verifica se o servidor é Glpi ou OCSInventory para fazer a substituição apropriada
read -p "1 - Glpi server | 2 - OCS server: " serverType

# Verifica se a opção selecionada é a 1
if [ $serverType -eq 1 ]
then
    # Realiza a substituição do parâmetro 'server' no arquivo de configuração do agente
    sed -i 's~.*com/glpi/plugins/fusioninventory.*~server = http://'"$uriServer"'~1' /etc/fusioninventory/agent.cfg

# Se não for a 1, verifica se a opção selecionada é a 2    
elif [ $serverType -eq 2 ]
then
    # Realiza a substituição do parâmetro 'server' no arquivo de configuração do agente
    sed -i 's~.*com/ocsinventory.*~server = http://'"$uriServer"'~1' /etc/fusioninventory/agent.cfg

# Se nenhuma das duas opções for escolhida
else
    # Sinaliza entrava inválida
    echo Invalid Input!
    # Termina a execução do script
    exit
fi

#Habilita os logs do FusionInventory
sed -i 's~.*logfile = .*~logfile = /var/log/fusioninventory.log~1' /etc/fusioninventory/agent.cfg

#Inicia o serviço do FusionInventory
systemctl restart fusioninventory-agent
sleep 5

#Inicia excução imediata do envio do inventário
pkill -USR1 -f -P 1 fusioninventory-agent
