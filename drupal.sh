#!/bin/bash

#####	NOME:			drupal.sh
#####	VERSAO:			1.0
#####	DESCRICAO:		Script destinado a preparar seu ambiente Linux para Desenvolver em projetos Drupal. Este script fará a instalação 
#####				de seu ambiente seguindo as melhores práticas de acordo com os padrões estabelecidos pelo Drupal Competence Office (DCO). 			
#####	DATA DA CRIACAO:	29/09/2021
#####	ESCRITO POR:		Gabriel Almeida
#####	E-MAIL:			gabrielda@ciandt.com 			
#####	DISTRO:			Ubuntu 20.04	
#####	LICENCA:		GPLv3 			
#####	PROJETO:                Drupal Setup Environment
#####   DOCUMENTACAO ORIGINAL:  https://docs.google.com/document/d/1hKdd0Tq05STi14jr4ARL2DvoK4VnMSOLXOrSjBQtePQ/edit 




#Mudando para diretorio home do usuario

 echo "Instalando dependencias necessárias para o script. Por gentileza, digitar sua senha sempre que solicitado."

 cd ~

########------------- Instalação do Docker ---------------#########


echo "Inicializando a instalação do Docker"
                                       

echo "Atualizando sua lista existente de pacotes\n"

sudo apt update 

echo "Instalando alguns pacotes pré-requisito que deixam o apt usar pacotes pelo HTTPS:\n"
sudo apt install apt-transport-https ca-certificates curl software-properties-common

echo "Adicionando a chave GPG para o repositório oficial do Docker no seu sistema:\n"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg |  apt-key add -

echo "Adicionando o repositório do Docker às fontes do APT:\n"
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

echo "Atualizando o banco de dados do pacote com os pacotes do Docker do recém adicionado repositório:\n"
sudo apt update

echo "Checando que você está prestes a instalar do repositório do Docker ao invés do repositório padrão do Ubuntu:\n"
echo "Log da instalação do Docker\n" > /tmp/aptcache_docker-ce.log
sudo apt-cache policy docker-ce  | head -n 3 &>> /tmp/aptcache_docker-ce.log



echo "Iniciando a Instalação do Docker: \n"
sudo apt install docker-ce

echo "O Docker agora será instalado, o daemon iniciado e o processo habilitado a iniciar no boot. Verificando se ele está funcionando:\n"
#not working
service docker status | head -n5



echo "Iniciando a configuração para executar o Comando Docker Sem Sudo\n"
#evitar digitar  sempre que você executar o comando docker, adicione seu nome de usuário no grupo docker:
#not working

usermod -aG docker ${USER}

#Para inscrever o novo membro ao grupo, saia do servidor e logue novamente, ou digite o seguinte:
echo "Por favor, insira sua senha:\n"
su - ${USER}


#Você será solicitado a digitar a senha do seu usuário para continuar.

#Confirme que seu usuário agora está adicionado ao grupo docker digitando:

id -nG

echo "Verificando a instalação:\n"
docker --version

echo "Docker instalado!! \n\n"

echo "####################################################################################################"
echo "Iniciando a instalação do Lando\n\n"

cd /tmp
curl -s https://api.github.com/repos/lando/lando/releases/latest | grep browser_download_url | grep x64 | grep .deb | cut -d '"' -f 4 | wget -qi -
sudo dpkg -i lando*.deb
rm lando*
cd ~

echo "Foi instalada a ultima versão do Lando!"
lando version



echo "####################################################################################################"


echo "Iniciando a instalação do VSCode\n\n"
cd /tmp
curl -o code.deb -L http://go.microsoft.com/fwlink/?LinkID=760868
sudo dpkg -i code.deb
rm code.deb
cd ~

echo "Instalando as extensões necessárias: \n\n"
code --install-extension ms-azuretools.vscode-docker
code --install-extension ikappas.composer
code --install-extension eiminsasete.apacheconf-snippets
code --install-extension tsega.drupal-8-twig-snippets
code --install-extension tsega.drupal-8-javascript-snippets
code --install-extension dssiqueira.drupal-8-snippets
code --install-extension sleistner.vscode-fileutils
code --install-extension felixfbecker.php-debug
code --install-extension bmewburn.vscode-intelephense-client
code --install-extension ikappas.phpcs
code --install-extension neilbrayfield.php-docblocker


##ATENCAO: Não é possivel instalar as extensões do chrome via terminal: https://stackoverflow.com/questions/16800696/how-install-crx-chrome-extension-via-command-line
echo "####################################################################################################"
echo "Iniciando a instalação do PHP\n\n"

sudo apt-get update
sudo apt-get install php7.4 php7.4-cli php7.4-mbstring php-xml



echo "####################################################################################################"
echo "Iniciando a instalação do Composer\n\n"

#https://getcomposer.org/download/



php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"

 mv composer.phar /usr/local/bin/composer

echo "Composer foi instalado com sucesso! \n"

composer -V





echo "####################################################################################################"
echo "Iniciando a instalação do PHPCS\n\n"


composer global require drupal/coder dealerdirect/phpcodesniffer-composer-installer

echo "Verificando a instalação: \n"
composer global show -P >> /tmp/log.txt
phpcs --config-set installed_paths ~/.config/composer/vendor/drupal/coder/coder_sniffer


phpcs -i | grep Drupal

sudo ln -s /usr/local/bin/HOME/.config/composer/vendor/squizlabs/php_codesniffer/bin/phpcs
sudo ln -s /usr/local/bin/HOME/.config/composer/vendor/squizlabs/php_codesniffer/bin/phpcbf


echo "####################################################################################################"
echo "Finalizando a instalação e removendo arquivos temporários\n\n"
echo "Concluído!"
exit



