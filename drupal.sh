#!/bin/bash

#!/bin/bash

#####	NAME:			             drupal.sh
#####	VERSION:			         2.0.0
#####	DESCRIPTION:	           	 This script will prepare your environment (Linux Ubuntu or Mac OS) getting you ready to develop in Drupal Projects. It will install  
#####				    your environment following best practices accordingly to the previously standards established by Drupal Competence Office (DCO) at CI&T. 			
#####	CREATION DATE:	             29/09/2021
#####   LAST UPDATE:                 11/11/2021
#####	AUTHOR:     		         Gabriel Almeida
#####	E-MAIL:		    	         gabrielda@ciandt.com 			
#####	LINUX RECOMMENDED DISTRO:	             Ubuntu 20.04
#####   MAC OS RECOMMENDED VERSION:              BigSur 11.1	
#####	LICENCE:		             GPLv3 			
#####	PROJECT:                     Drupal Setup Environment


## Checking OS Type
clear

echo "\033[1m This script will prepare your environment (Linux Ubuntu or Mac OS) getting you ready to develop in Drupal Projects. Shall we start? \033[0;0m"
sleep 3
echo '\033[31m###############################################################################################\033[0;0m'
echo "\033[1m\n\n Detecting your OS, just a minute...\n\033[0;0m"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "\033[1m\n\n Linux detected! \n\033[0;0m"

    #Changing to HOME directory

    echo "\033[1m\n Installing necessary dependencies... \n\n I know that this is going to work. Because, if not, I don't know what to do. \n\n Please, enter your password when asked. \n\033[0;0m"

    cd ~/Downloads

    sudo apt update -y
    sleep 3
    clear
    sudo apt install wget -y
    sleep 3
    clear
    sudo apt install curl -y
    sleep 3


    ########------------- Docker Installation ---------------#########
    clear
    echo '\033[31m###############################################################################################\033[0;0m'

    echo "\033[1m \n\n Starting to install Docker \n\033[0;0m"


    echo "\033[1m \n\n Installing a few packeges to allow apt install via HTTPS: \n\033[0;0m"
    sudo apt install apt-transport-https ca-certificates software-properties-common -y
    sleep 3
    clear

    echo "\033[1m\nAdding GPG key to Docker's official repository:\n\033[0;0m"
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sleep 3
    clear

    echo "\033[1m\nAdding Docker's repository to apt sources:\n\033[0;0m"
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
    sleep 3
    clear

    echo "\033[1m\nUpdating apt database with Docker's packages from the recently added repo:\n\033[0;0m"
    sudo apt update -y
    sleep 3
    clear

    echo "\033[1m\nChecking that you are ready to install from Docker's repo instead of Ubuntu's standard repo:\n\033[0;0m"
    sudo apt-cache policy docker-ce  | head -n 3 
    sleep 3
    clear

    echo "\033[1m\nStarting to install Docker: \n\033[0;0m"
    sudo apt install docker-ce -y
    sleep 3
    clear

    echo "\033[1m\nDocker will now be installed, its deamon started and the process will be iniciated on boot. Verifying if it is working:\n\033[0;0m"
    service docker status | head -n5
    sleep 3
    clear

    echo "\033[1m\nConfiguring Docker to run without sudo\n\033[0;0m"
    #It allows you to type whenever you execute docker command, adding your username in docker group:

    sudo usermod -aG docker ${USER}


    #Verify that your username is now added to docker group:

    id -nG

    echo "\033[1m\nVerifying the install:\n\033[0;0m"
    docker --version

    echo "\033[34m\nDocker was installed successfully!!\nYay! I can do this all day\n\033[0;0m"
    sleep 5

    echo "\033[31m####################################################################################################\033[0;0m"
    echo "\033[1m\n\Starting Lando install:\n\033[0;0m"
    sleep 3
    cd /tmp
    curl -s https://api.github.com/repos/lando/lando/releases/latest | grep browser_download_url | grep x64 | grep .deb | cut -d '"' -f 4 | wget -qi -
    sudo dpkg -i lando*.deb
    rm lando*
    cd ~

    sleep 3
    clear
    echo "\033[34m\n\nLando's latest version is now installed!\n Developers, assemble! \033[0;0m"
    lando version

    sleep 5
    clear

    echo "\033[1m####################################################################################################\033[0;0m"
    echo "\033[1m\n\n Starting VSCode installation: \n\033[0;0m"
    cd /tmp
    curl -o code.deb -L http://go.microsoft.com/fwlink/?LinkID=760868
    sudo dpkg -i code.deb
    rm code.deb
    cd ~

    sleep 3
    clear

    echo "\033[1m\n\nInstalling VSCode extensions: \n\n\033[0;0m"
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
    code --install-extension whatwedo.twig

    sleep 3
    clear

    echo "\033[34m\n\n Installed VSCode and its extensions: \n Don't forget: With great power comes great responsibility. \n\033[0;0m"
    code -v
    code --list-extensions | sed -e 's/^/code --install-extension /'
    sleep 5


    ##ATTENTION: It's not possible to install Chrome extension via shell according to this thread: https://stackoverflow.com/questions/16800696/how-install-crx-chrome-extension-via-command-line
    
    clear
    echo "\033[1m#################################################################################\033[0;0m"

    i=0
    while [ $i = 0 ]
    do
        i=1
        echo "\033[1mWe are now going to install PHP! Which version of PHP doyou want to install? \n\n\033[0;0m"
        echo '\033[33m1 - PHP 7.4\n\033[0;0m'
        echo '\033[33m2 - PHP 8.0\n\n\033[0;0m'
        read PHP_INPUT

        case $PHP_INPUT in

        1) 
            sudo add-apt-repository ppa:ondrej/php && sudo apt-get update -y && sudo apt -y install software-properties-common && sudo apt-get install php7.4 php7.4-cli php7.4-mbstring php-xml -y
            sleep 3
            ;;

        2) 
            sudo add-apt-repository ppa:ondrej/php && sudo apt-get update -y && sudo apt -y install software-properties-common && sudo apt-get install php8.0 php8.0-cli php8.0-mbstring php-xml -y
            sleep 3
            ;;
        
        *)
            echo "\033[1mPlease choose 1 or 2 \033[0;0m"
            sleep 3
            clear
        esac
        i=1
    done
    echo "\033[1m\n\n PHP was installed successfully! \n This is inevitable! \033[0m;0m"

    php -v

    sleep 5
    clear

    echo "\033[1m#################################################################################\033[0;0m"
    echo "\033[1mStarting Composer installation: \n\033[0;0m"

    #https://getcomposer.org/download/


    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo -e 'Installer verified'; } else { echo -e 'Installer corrupt'; unlink('composer-setup.php'); } echo -e PHP_EOL;"
    php composer-setup.php
    php -r "unlink('composer-setup.php');"

    sudo mv composer.phar /usr/local/bin/composer
    sleep 3
    clear

    echo "\033[1m\nComposer was installed successfully! \n If we're going to win this fight, some of us might have to loose it. \n\n\033[0;0m"

    composer -V
    sleep 5
    clear

    echo "\033[31m#################################################################################\033[0;0m"
    echo "\033[1mStarting to install PHPCS: \n\033[0;0m"

    composer global require drupal/coder dealerdirect/phpcodesniffer-composer-installer

    cd /usr/local/bin

    sudo ln -s $HOME/.config/composer/vendor/squizlabs/php_codesniffer/bin/phpcs
    sudo ln -s $HOME/.config/composer/vendor/squizlabs/php_codesniffer/bin/phpcbf

    echo "\033[1m\n\n Always test you code! Whatever it takes. \n\033[0;0m"
    sleep 5

    phpcs --config-set installed_paths ~/.config/composer/vendor/drupal/coder/coder_sniffer

    sleep 5
    clear

    echo "\033[31m#################################################################################\033[0;0m"
    echo "\033[1m\n\n Starting to install PHP Unit: \n\033[0;0m]"

    wget -0 phpunit https://phar.phpunit.de/phpunit-9.phar
    chmod +x phpunit

    echo "\033[1m\n PHP Unit was installed successfully! \n\n\033[0;0m]"

    ./phpunit --version

    echo '\033[31m##################################################################################\033[0;0m]'
    echo "\033[1m\n\n Part of the journey is the end. It's all set! You can now develop with Drupal :) \033[0;0m]"

    sleep 5
exit


elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "\033[1m\nMac OS detected!\n\033[0;0m]"

    echo "\033[1m\nInstalling necessary dependencies... Please, enter your password when asked.\n\033[0;0m"

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
    brew install curl
    


    echo '\033[031m####################################################################################################\033[0;0m'
    echo "Starting Lando & Docker installation:"

    brew install --cask lando

    echo "Lando's latest version is now installed!"
    lando version


    echo '\033[031m####################################################################################################\033[0;0m'


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
    code --install-extension whatwedo.twig


    ##ATTENTION: It's not possible to install Chrome extension via shell according to this thread: https://stackoverflow.com/questions/16800696/how-install-crx-chrome-extension-via-command-line
    echo '\033[031m####################################################################################################\033[0;0m'
    echo "We are now going to install PHP! \033[0;0m"
    echo '\033[33mPHP 7.4\033[0;0m'
                brew tap shivammathur/php
                #check if php is currently installed
                PHP_VERSION="php -v | grep 'PHP 7'"
                #if it is, upgrade to chosen version
                if [[ -n $PHP_VERSION ]]; then 
                    brew install shivammathur/php/php@7.4
                    brew link --overwrite --force php@7.4
                    cd ~
                fi


    echo '\033[031m####################################################################################################\033[0;0m'
    echo "Starting Composer installation: "



    curl -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer
    chmod +x /usr/local/bin/composer

    echo "Composer was installed successfully! "

    composer -V


    echo '\033[031m####################################################################################################\033[0;0m'
    echo "Starting to install PHPCS: "

    echo " " >> ~/.bash_profile
    echo "export PATH=""$HOME"/.composer/vendor/bin:"$PATH""" >> ~/.bash_profile
    echo " " >> ~/.bash_profile
    source ~/.bash_profile



    composer global require squizlabs/php_codesniffer


    cd /usr/local/bin || return

    sudo ln -s "$HOME"/.config/composer/vendor/squizlabs/php_codesniffer/bin/phpcs
    sudo ln -s "$HOME"/.config/composer/vendor/squizlabs/php_codesniffer/bin/phpcbf

    echo "Checking if everything is OK: "

    which phpcs

    echo '\033[031m####################################################################################################\033[0;0m'
    echo "It's all set! You can now develop with Drupal :)"
    exit
fi


## END OF FILE ##