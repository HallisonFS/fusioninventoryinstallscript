#Instalação do Fusion Invrntory em distribuições Linux baseadas em Debian
#Version: 1.0
#Última alteração: 29/07/2019 - 09:02
#Criador: Hallison F. da Silva
#Alterado por:


#!/bin/bash
#Acessa a home do usuário
cd ~
#Instala as dependências
apt -y install dmidecode hwdata ucf hdparm
apt -y install perl libuniversal-require-perl libwww-perl libparse-edid-perl
apt -y install libproc-daemon-perl libfile-which-perl libhttp-daemon-perl
apt -y install libxml-treepp-perl libyaml-perl libnet-cups-perl libnet-ip-perl
apt -y install libdigest-sha-perl libsocket-getaddrinfo-perl libtext-template-perl
apt -y install libxml-xpath-perl
#Faz download do pacote FusionInventory
wget https://github.com/fusioninventory/fusioninventory-agent/releases/download/2.5.1/fusioninventory-agent_2.5.1-1_all.deb
#Instala o pacote 
dpkg -i fusioninventory-agent_2.5.1-1_all.deb
#Substitui o parâmetro do servidor executando o FusionInventory
sed -i 's~#server = http://server.domain.com/glpi/plugins/fusioninventory/~server = http://myglpiserver.com/glpi/plugins/fusioninventory/~1' /etc/fusioninventory/agent.cfg
#Habilita os logs do FusionInventory
sed -i 's~#logfile = /var/log/fusioninventory.log~logfile = /var/log/fusioninventory.log~1' /etc/fusioninventory/agent.cfg
#Inicia o serviço do FusionInventory
systemctl restart fusioninventory-agent
sleep 10
#Inicia excução imediata do envio do inventário
pkill -USR1 -f -P 1 fusioninventory-agent
