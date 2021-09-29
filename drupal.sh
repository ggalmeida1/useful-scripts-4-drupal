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




#Mudando para diretorio HOME

 echo "^[[31m^[[1mInstalando dependencias necessárias para o script. Por gentileza, digitar sua senha sempre que solicitado.^[[0m"

 cd ~/Downloads

 sudo apt update
 sudo apt upgrade
 sudo apt install wget
 sudo apt install curl
 

########------------- Instalação do Docker ---------------#########


echo "^[[31m^[[1mInicializando a instalação do Docker^[[0m"
                                       

echo "^[[31m^[[1mInstalando alguns pacotes pré-requisito que deixam o apt usar pacotes pelo HTTPS:\n^[[0m"
sudo apt install apt-transport-https ca-certificates software-properties-common

echo "^[[31m^[[1mAdicionando a chave GPG para o repositório oficial do Docker no seu sistema:\n^[[0m"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -


echo "^[[31m^[[1mAdicionando o repositório do Docker às fontes do APT:\n^[[0m"
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"


echo "^[[31m^[[1mAtualizando o banco de dados do pacote com os pacotes do Docker do recém adicionado repositório:\n^[[0m"
sudo apt update

echo "^[[31m^[[1mChecando que você está prestes a instalar do repositório do Docker ao invés do repositório padrão do Ubuntu:\n^[[0m"
sudo apt-cache policy docker-ce  | head -n 3 


echo "^[[31m^[[1mIniciando a Instalação do Docker: \n^[[0m"
sudo apt install docker-ce

echo "^[[31m^[[1mO Docker agora será instalado, o daemon iniciado e o processo habilitado a iniciar no boot. Verificando se ele está funcionando:\n^[[0m"
service docker status | head -n5


echo "^[[31m^[[1mIniciando a configuração para executar o Comando Docker Sem Sudo\n^[[0m"
#evitar digitar  sempre que você executar o comando docker, adicione seu nome de usuário no grupo docker:

sudo usermod -aG docker ${USER}


#Confirme que seu usuário agora está adicionado ao grupo docker digitando:

id -nG

echo "^[[31m^[[1mVerificando a instalação:\n^[[0m"
docker --version

echo "^[[31m^[[1mDocker instalado!! \n\n^[[0m"

echo "^[[31m^[[1m####################################################################################################^[[0m"
echo "^[[31m^[[1mIniciando a instalação do Lando\n\n^[[0m"

cd /tmp
curl -s https://api.github.com/repos/lando/lando/releases/latest | grep browser_download_url | grep x64 | grep .deb | cut -d '"' -f 4 | wget -qi -
sudo dpkg -i lando*.deb
rm lando*
cd ~

echo "^[[31m^[[1mFoi instalada a ultima versão do Lando!^[[0m"
lando version

echo "^[[31m^[[1m####################################################################################################^[[0m"


echo "^[[31m^[[1mIniciando a instalação do VSCode\n\n^[[0m"
cd /tmp
curl -o code.deb -L http://go.microsoft.com/fwlink/?LinkID=760868
sudo dpkg -i code.deb
rm code.deb
cd ~

echo "^[[31m^[[1mInstalando as extensões necessárias: \n\n^[[0m"
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
echo "^[[31m^[[1m#################################################################################^[[0m"
echo "^[[31m^[[1mIniciando a instalação do PHP\n\n^[[0m"

sudo apt-get update
sudo apt-get install php7.4 php7.4-cli php7.4-mbstring php-xml


echo "^[[31m^[[1m#################################################################################^[[0m"
echo "^[[31m^[[1mIniciando a instalação do Composer\n\n^[[0m"

#https://getcomposer.org/download/


php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"

sudo mv composer.phar /usr/local/bin/composer

echo "^[[31m^[[1mComposer foi instalado com sucesso! \n^[[0m"

composer -V


echo "^[[31m^[[1m#################################################################################^[[0m"
echo "^[[31m^[[1mIniciando a instalação do PHPCS\n\n^[[0m"


composer global require drupal/coder dealerdirect/phpcodesniffer-composer-installer


cd /usr/local/bin

sudo ln -s $HOME/.config/composer/vendor/squizlabs/php_codesniffer/bin/phpcs
sudo ln -s $HOME/.config/composer/vendor/squizlabs/php_codesniffer/bin/phpcbf

echo "^[[31m^[[1mVerificando a instalação: \n^[[0m"

phpcs --config-set installed_paths ~/.config/composer/vendor/drupal/coder/coder_sniffer

echo "^[[31m^[[1m#################################################################################^[[0m"
echo "^[[31m^[[1mConcluído!^[[0m"
exit


## END OF FILE ##