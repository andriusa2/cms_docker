#!/bin/sh
# Misc system configuration (timezone, systemd, etc)
# Expected config files:
# /tmp/systemd/resolved.conf.d/ => /etc/systemd/resolved.conf.d/
# /tmp/grub => /etc/default/grub.d

set -eux

# Set system timezone to Europe/Vilnius
# Note that timedatectl set-timezone could be used, but this then leaves
# /etc/timezone in inconsistent state. dpkg-reconfigure handles itself better.
echo 'tzdata tzdata/Areas select Europe' | sudo debconf-set-selections
echo 'tzdata tzdata/Zones/Europe select Vilnius' | sudo debconf-set-selections
sudo rm /etc/timezone /etc/localtime
sudo dpkg-reconfigure -f noninteractive tzdata
cat /etc/timezone
ls -l /etc/localtime

# Add kernel boot line
# This makes use of a debian-specific grub patch which exposes
# /etc/default/grub.d/*.cfg as a directory for overrides.
# See "default-grub-d.patch" and https://bugs.launchpad.net/bugs/901600
sudo install -o root -g root -m 644 /tmp/grub/*.cfg /etc/default/grub.d/
sudo update-grub

# Add systemd-resolved overrides
sudo install -o root -g root -d /etc/systemd/resolved.conf.d/
sudo install -o root -g root -m 644 /tmp/systemd/resolved.conf.d/* /etc/systemd/resolved.conf.d/
sudo systemctl restart systemd-resolved
