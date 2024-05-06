#!/bin/bash

# Exit script when SIGINT sent
function handle_sigint {
    echo "Received SIGINT. Exiting..."
    exit 1
}
trap 'handle_sigint' SIGINT

#### Check for files and directories needed to work
echo "==Checking for important directories/files"
# Check for apache2 config
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
# Check for php fpm file for apache2
filecheck=apache2/conf-available/php$PHP_VERSION-fpm.conf
if ! [ -f "/etc/$filecheck" ]; then
  echo "PHP$PHP_VERSION FPM config missing, restoring"
  cp -ar /app/default/$filecheck /etc/$filecheck
fi
# Check for php version folder
foldercheck=/etc/php/$PHP_VERSION
if [ -z "$(ls -A "$foldercheck")" ]; then
    echo "Empty php config, restoring defaults"
    mkdir /etc/php
    cp -ar /app/default/php/$PHP_VERSION /etc/php/$PHP_VERSION
fi
# Check for www
foldercheck=/var/www
if [ -z "$(ls -A "$foldercheck")" ]; then
    echo "Empty www, restoring defaults"
    mkdir /var/www
    cp -ar /app/default/www /var/www
fi


# Make dir for php (idk bandaid solution fn)
mkdir -p /run/php/
# Fixing permissions of /var/www
chown www-data:www-data /var/www -R

echo
############### Update packages
echo "== Update packages"
# Update packages
apt update
apt upgrade -y
echo

############# List out packages and other stuffs
# List php modules (and its packages)
echo "==Listing PHP Modules"
php -m
echo "==Listing PHP Module Packages"
apt list --installed | grep php$PHP_VERSION
echo


############ Enabling modules, confs and sites
# Apache2 modules
echo "==Enabling apache2 modules..."
module_file="/app/modules/apache2-modules.txt"
if [ -f "$module_file" ]; then
    sed -i 's/\r$//' $module_file
    sed -i -e '$a\' $module_file
    while IFS= read -r module; do
        if [[ $module == -* ]]; then
            module=${module#*-}
            echo "Disabling $module"
            a2dismod "$module" > /dev/null 2>&1
        else
            echo "Enabling $module"
            a2enmod "$module" > /dev/null 2>&1
        fi
    done < "$module_file"
else
    echo "file '$module_file' not found."
    exit 1
fi
# Apache2 confs
echo
echo "==Enabling apache2 confs..."
a2enconf php$PHP_VERSION-fpm
conf_file="/app/modules/apache2-confs.txt"
if [ -f "$conf_file" ]; then
    sed -i 's/\r$//' $conf_file
    sed -i -e '$a\' $conf_file
    while IFS= read -r module; do
        if [[ $module == -* ]]; then
            module=${module#*-}
            echo "Disabling $module"
            a2disconf "$module" > /dev/null 2>&1
        else
            echo "Enabling $module"
            a2enconf "$module" > /dev/null 2>&1
        fi
    done < "$conf_file"
else
    echo "file '$conf_file' not found."
    exit 1
fi
# Apache2 sites
echo
echo "==Enabling apache2 sites..."
site_file="/app/modules/apache2-sites.txt"
if [ -f "$site_file" ]; then
    sed -i 's/\r$//' $site_file
    sed -i -e '$a\' $site_file
    while IFS= read -r module; do
        if [[ $module == -* ]]; then
            module=${module#*-}
            echo "Disabling $module"
            a2dissite "$module" > /dev/null 2>&1
        else
            echo "Enabling $module"
            a2ensite "$module" > /dev/null 2>&1
        fi
    done < "$site_file"
else
    echo "file '$site_file' not found. Enabling default site config"
    exit 1
fi

echo
############# Print version numbers
echo "==Apache Version"
apachectl -v
echo "==PHP Version"
php --version
echo ""

############ Start apache2 and php
echo "==Starting software"
# FPM service
/etc/init.d/php$PHP_VERSION-fpm restart

# Apache service
/etc/init.d/apache2 start

# Keep service alive until SIGINT (better solution than a infinite loop)
sleep infinity
