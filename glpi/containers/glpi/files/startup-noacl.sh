#!/bin/bash -e

# set ACL fails with "operation not permited" on Docker Desktop
# seems an obscure bug of docker

# Run cron service.
cron

# ensure that volumes have the right owner and permissions
for d in config files ; do
    chown -R www-data:www-data /var/www/glpi/$d
    # chmod not yet
done

# Run command previously defined in base php-apache Dockerfile.
apache2-foreground

