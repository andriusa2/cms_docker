#!/bin/sh
# Install nginx and supervisor to run the services.
# Note that their configs must have been copied to /tmp beforehand.
# Namely the following are required:
# - /tmp/cms => /usr/local/etc
# - /tmp/nginx => /etc/nginx
# - /tmp/supervisor => /etc/supervisor
# - /tmp/cppreference.zip =unzip=> /usr/share/doc/cppreference
# - /tmp/dejavu-fonts.zip =unzip=> /usr/share/doc/cppreference
# - /tmp/www => /var/www/

set -eux

sudo apt-get install -y nginx supervisor unzip
sudo install -o cmsuser -g cmsuser -m 664 /tmp/cms/* /usr/local/etc
# There's some expectation of directory structure here.
sudo chown -R root:cmsuser /tmp/www/
sudo chmod -R 664 /tmp/www/
sudo cp -r /tmp/www/* /var/www/

# cppreference is a bit more annoying than usual here as we need to vendor
# the fonts.
sudo unzip -q /tmp/cppreference.zip -d /usr/share/doc/ 'reference/*'
sudo mv /usr/share/doc/reference /usr/share/doc/cppreference
sudo unzip -q -o /tmp/dejavu-fonts.zip -d /usr/share/doc/cppreference/
sudo chmod -R u+rwX,go=rX /usr/share/doc/cppreference

# Supervisor configs
sudo install -o root -g root -m 664 /tmp/supervisor/supervisord.conf /etc/supervisor
sudo install -o root -g root -m 664 -d /etc/supervisor/conf.d
sudo install -o root -g root -m 664 /tmp/supervisor/conf.d/* /etc/supervisor/conf.d

# nginx
sudo install -o root -g root -m 664 /tmp/nginx/nginx.conf /etc/nginx
sudo install -o root -g root -m 664 /tmp/nginx/sites-enabled/* /etc/nginx/sites-enabled
sudo install -o root -g root -m 664 /tmp/nginx/sites-available/* /etc/nginx/sites-available
sudo nginx -t
