#!/bin/bash

# Exit script when SIGINT sent
function handle_sigint {
    echo "Received SIGINT. Exiting..."
    exit 1
}
trap 'handle_sigint' SIGINT

# Check if directories exist
foldercheck=/etc/apache2
if [ -z "$(ls -A "$foldercheck")" ]; then
    echo "Empty apache config, restoring defaults"

    # Copy defaults
    cp -ar /app/default/apache2 /etc/
    cp -ar /app/default/www /var/
    # permissions
    chown www-data:www-data /var/www -R
    chown root:root /etc/apache2 -R
fi
foldercheck=/etc/php
if [ -z "$(ls -A "$foldercheck")" ]; then
    echo "Empty php config, restoring defaults"
    cp -ar /app/default/php /etc/
fi

# Apache2 modules
echo "Enabling apache2 modules..."
module_file="/app/modules/apache2-modules.txt"
if [ -f "$module_file" ]; then
    sed -i 's/\r$//' $module_file
    sed -i -e '$a\' $module_file
    while IFS= read -r module; do
        if [[ $module == -* ]]; then
            module=${module#*-}
            echo "Disabling $module"
            a2dismod "$module"
        else
            echo "Enabling $module"
            a2enmod "$module"
        fi
    done < "$module_file"
else
    echo "file '$module_file' not found."
    exit 1
fi
# Apache2 confs
echo "Enabling apache2 confs..."
conf_file="/app/modules/apache2-confs.txt"
if [ -f "$conf_file" ]; then
    sed -i 's/\r$//' $conf_file
    sed -i -e '$a\' $conf_file
    while IFS= read -r module; do
        if [[ $module == -* ]]; then
            module=${module#*-}
            echo "Disabling $module"
            a2disconf "$module"
        else
            echo "Enabling $module"
            a2enconf "$module"
        fi
    done < "$conf_file"
else
    echo "file '$conf_file' not found."
    exit 1
fi
# Apache2 sites
echo "Enabling apache2 sites..."
site_file="/app/modules/apache2-sites.txt"
if [ -f "$site_file" ]; then
    sed -i 's/\r$//' $site_file
    sed -i -e '$a\' $site_file
    while IFS= read -r module; do
        if [[ $module == -* ]]; then
            module=${module#*-}
            echo "Disabling $module"
            a2dissite "$module"
        else
            echo "Enabling $module"
            a2ensite "$module"
        fi
    done < "$site_file"
else
    echo "file '$site_file' not found. Enabling default site config"
    exit 1
fi


# FPM service
/etc/init.d/php8.1-fpm restart

# Apache service
/etc/init.d/apache2 start


# Lock for 
while true; do
    # permissions
    chown www-data:www-data /var/www -R
    sleep 1
done