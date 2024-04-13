#!/bin/bash

PHPBASEVER=8.1

cd /app

# Update packages
apt update

# Install apache2 and php
apt install -y apache2 php$PHPBASEVER php$PHPBASEVER-fpm --no-install-recommends

# Disable the default site file by default (it will be enabled on startup of container due to the default apache2-sites.txt file)
a2dissite 000-default

# PHP Extensions
extension_file="/app/php-extensions.txt"
if [ -f "$extension_file" ]; then
	sed -i 's/\r$//' $extension_file
	sed -i -e '$a\' $extension_file

	sed_string="s/.*/php$PHPBASEVER-&/g"
	modules=$(sed "$sed_string" "$extension_file" | tr '\n' ' ')
	apt install --no-install-recommends --ignore-missing -y $modules
	if [ $? -ne 0 ]; then
        echo "Error occurred during apt installation. Exiting..."
        exit 1
    fi
else
    echo "Extensions file '$module_file' not found."
    exit 1
fi

# Additional packages
add_packages="/app/additional-packages.txt"
if [ -f "$add_packages" ]; then
    sed -i 's/\r$//' $add_packages
	sed -i -e '$a\'  $add_packages
	modules=$(<"$add_packages" tr '\n' ' ')
	apt install --no-install-recommends --ignore-missing -y $modules
	if [ $? -ne 0 ]; then
        echo "Error occurred during apt installation. Exiting..."
        exit 1
    fi
else
    echo "file '$module_file' not found."
    exit 1
fi

# Backup default of apache2
mkdir /app/default
cp -ar /etc/apache2/ /app/default/apache2
cp -ar /var/www/ /app/default/www
# Php backup
cp -ar /etc/php /app/default/php

