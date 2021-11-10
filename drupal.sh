#!/bin/bash

#####	NAME:			             drupal.sh
#####	VERSION:			         1.0.1
#####	DESCRIPTION:	           	 This script will prepare your environment (Linux Ubuntu) getting you ready to develop in Drupal Projects. It will install  
#####				    your environment following best practices accordingly to the previously standards established by Drupal Competence Office (DCO). 			
#####	CREATION DATE:	             29/09/2021
#####   LAST UPDATE:                 30/09/2021
#####	AUTHOR:     		         Gabriel Almeida
#####	E-MAIL:		    	         gabrielda@ciandt.com 			
#####	LINUX DISTRO:	             Ubuntu 20.04	
#####	LICENCE:		             GPLv3 			
#####	PROJECT:                     Drupal Setup Environment
#####   ORIGINAL DOCUMENTATION:      https://docs.google.com/document/d/1hKdd0Tq05STi14jr4ARL2DvoK4VnMSOLXOrSjBQtePQ/edit 



#####   NEXT IMPROVEMENT: ALLOW USER TO DECIDE WICH VERSION OF PHP WILL BE INSTALLED.
#####   STATUS: APPROVED. WORK IN PROGRESS.
#####   ETA FOR RELEASE: 10/10/21


#Changing to HOME directory

 echo "\033[1mInstalling necessary dependencies... Please, enter your password when asked."

 cd ~/Downloads

 sudo apt update
 sudo apt upgrade
 sudo apt install wget
 sudo apt install curl
 

########------------- Docker Installation ---------------#########


echo "\033[1mStarting to install Docker"
                                       

echo "\033[1mInstalling a few packeges to allow apt install via HTTPS:\n"
sudo apt install apt-transport-https ca-certificates software-properties-common

echo "\033[1mAdding GPG key to Docker's official repository:\n"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -


echo "\033[1mAdding Docker's repository to apt sources:\n"
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"


echo "\033[1mUpdating apt database with Docker's packages from the recently added repo:\n"
sudo apt update

echo "\033[1mChecking that you are ready to install from Docker's repo instead of Ubuntu's standard repo:\n"
sudo apt-cache policy docker-ce  | head -n 3 


echo "\033[1mStarting to install Docker: \n"
sudo apt install docker-ce

echo "\033[1mDocker will now be installed, its deamon started and the process will be iniciated on boot. Verifying if it is working:\n"
service docker status | head -n5


echo "\033[1mConfiguring Docker to run without sudo\n"
#It allows you to type whenever you execute docker command, adding your username in docker group:

sudo usermod -aG docker ${USER}


#Verify that your username is now added to docker group:

id -nG

echo "\033[1mVerifying the install:\n"
docker --version

echo "\033[1mDocker installed successfully!!\n\n"

echo "\033[1m####################################################################################################"
echo "\033[1mStarting Lando install:\n\n"

cd /tmp
curl -s https://api.github.com/repos/lando/lando/releases/latest | grep browser_download_url | grep x64 | grep .deb | cut -d '"' -f 4 | wget -qi -
sudo dpkg -i lando*.deb
rm lando*
cd ~

echo "\033[1mLando's latest version is now installed!"
lando version

echo "\033[1m####################################################################################################"


echo "\033[1mStarting VSCode installation:\n\n"
cd /tmp
curl -o code.deb -L http://go.microsoft.com/fwlink/?LinkID=760868
sudo dpkg -i code.deb
rm code.deb
cd ~

echo "\033[1mInstalling VSCode extensions: \n\n"
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


##ATTENTION: It's not possible to install Chrome extension via shell according to this thread: https://stackoverflow.com/questions/16800696/how-install-crx-chrome-extension-via-command-line
echo "\033[1m#################################################################################"
echo "\033[1mWe are now going to install PHP: \n\n"

sudo apt-get update
sudo apt-get install php7.4 php7.4-cli php7.4-mbstring php-xml


echo "\033[1m#################################################################################"
echo "\033[1mStarting Composer installation: \n\n"

#https://getcomposer.org/download/


php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo -e 'Installer verified'; } else { echo -e 'Installer corrupt'; unlink('composer-setup.php'); } echo -e PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"

sudo mv composer.phar /usr/local/bin/composer

echo "\033[1mComposer was installed successfully! \n"

composer -V


echo "\033[1m#################################################################################"
echo "\033[1mStarting to install PHPCS: \n\n"


composer global require drupal/coder dealerdirect/phpcodesniffer-composer-installer


cd /usr/local/bin

sudo ln -s $HOME/.config/composer/vendor/squizlabs/php_codesniffer/bin/phpcs
sudo ln -s $HOME/.config/composer/vendor/squizlabs/php_codesniffer/bin/phpcbf

echo "\033[1mChecking everything is OK: \n"

phpcs --config-set installed_paths ~/.config/composer/vendor/drupal/coder/coder_sniffer

echo "\033[1m#################################################################################"
echo "\033[1mIt's all set! You can now develop with Drupal :)"
exit


## END OF FILE ##