#!/bin/bash

#####	NAME:			             drupal.sh
#####	VERSION:			         2.0.0
#####	DESCRIPTION:	           	 This script will prepare your environment (Linux Ubuntu) getting you ready to develop in Drupal Projects. It will install  
#####				    your environment following best practices accordingly to the previously standards established by Drupal Competence Office (DCO). 			
#####	CREATION DATE:	             29/09/2021
#####   LAST UPDATE:                 16/11/2021
#####	AUTHOR:     		         Gabriel Almeida
#####	E-MAIL:		    	         gabrielda@ciandt.com 			
#####	LINUX DISTRO:	             Ubuntu 20.04	
#####	LICENCE:		             GPLv3 			
#####	PROJECT:                     Drupal Setup Environment
#####   ORIGINAL DOCUMENTATION:      https://docs.google.com/document/d/1hKdd0Tq05STi14jr4ARL2DvoK4VnMSOLXOrSjBQtePQ/edit 


## Checking OS Type

echo 'Detecting your OS, just a minute...'

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Linux detected!"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Darwin detected!"

    echo "Installing necessary dependencies... Please, enter your password when asked."

    #Changing to HOME directory
    cd ~/Downloads || return

    ## install the Xcode command-line tool
    xcode-select --install


    ## install the HomeBrew Package Manager 
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null 2> /dev/null
    brew update
    brew upgrade
    brew cleanup
    brew doctor
    ## install curl
    brew install curl
    


    echo "####################################################################################################"
    echo "Starting Lando & Docker installation:"

    brew install --cask lando

    echo "Lando's latest version is now installed!"
    lando version
    #docker --version

    echo "####################################################################################################"
    ################

    echo "Starting VSCode installation:"
    brew install --cask visual-studio-code

    echo "Installing VSCode extensions: "
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
    echo "#################################################################################"
    printf "We are now going to install PHP! \033[0;0m"
    printf '\033[33mPHP 7.4\033[0;0m'
                brew tap shivammathur/php
                #check if php is currently installed
                PHP_VERSION="php -v | grep 'PHP 7'"
                #if it is, upgrade to chosen version
                if [[ -n $PHP_VERSION ]]; then 
                    brew install shivammathur/php/php@7.4
                    brew link --overwrite --force php@7.4
                    cd ~
                fi


    echo "#################################################################################"
    printf "Starting Composer installation: "

    #https://getcomposer.org/download/


    curl -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer
    chmod +x /usr/local/bin/composer

    printf "Composer was installed successfully! "

    composer -V


    echo "#################################################################################"
    echo "Starting to install PHPCS: "

    echo " " >> ~/.bash_profile
    echo "export PATH=""$HOME"/.composer/vendor/bin:"$PATH""" >> ~/.bash_profile
    echo " " >> ~/.bash_profile
    source ~/.bash_profile



    composer global require squizlabs/php_codesniffer


    #cd /usr/local/bin || return

    #sudo ln -s "$HOME"/.config/composer/vendor/squizlabs/php_codesniffer/bin/phpcs
    #sudo ln -s "$HOME"/.config/composer/vendor/squizlabs/php_codesniffer/bin/phpcbf

    echo "Checking if everything is OK: "

    which phpcs

    echo "#################################################################################"
    echo "It's all set! You can now develop with Drupal :)"
    exit
fi


## END OF FILE ##