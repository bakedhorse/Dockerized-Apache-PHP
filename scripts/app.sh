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