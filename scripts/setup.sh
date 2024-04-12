#!/bin/bash

cd /app

# Update packages
apt update

# Install apache2 and php
apt install -y apache2 php8.1 php8.1-fpm --no-install-recommends

# Apache2 modules
module_file="/app/apache2-modules.txt"
if [ -f "$module_file" ]; then
	modules=$(tr '\n' ' ' < "$module_file")
    a2enmod $modules
else
    echo "Module file '$module_file' not found."
    exit 1
fi

# PHP Extensions
extension_file="/app/php-extensions.txt"
if [ -f "$extension_file" ]; then
	modules=$(sed 's/.*/php8.1-&/' "$extension_file" | tr '\n' ' ')
	apt install --no-install-recommends -y $modules
else
    echo "Extensions file '$module_file' not found."
    exit 1
fi

# Enable php fpm config for apache2
a2enconf php8.1-fpm


# Backup default of apache2
mkdir /app/default
cp -ar /etc/apache2/ /app/default/apache2
cp -ar /var/www/ /app/default/www
# Php backup
cp -ar /etc/php /app/default/php

