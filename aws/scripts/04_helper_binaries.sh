#!/bin/bash
# Install a suite of helper binaries for automation/logging purposes.
# All executables put to /tmp/cms-misc-bin will be installed into
# /usr/local/bin.
# All services put to /tmp/cms-misc-services will be installed as system
# services.
set -eux

# Set up venv with required dependencies.
pyenv virtualenv aws-automation
pyenv activate aws-automation
pip3 install boto3 psycopg2

# Adjust python shebangs to venv python
# TODO - this normally should be done via setuptools, so fix that.
sed -s -i -e 'sT#!/usr/bin/env python3T#!'"${VIRTUAL_ENV}/bin/python3T" /tmp/cms-misc-bin/*
sudo install -o root -g root -m 755 /tmp/cms-misc-bin/* /usr/local/bin
sudo install -o root -g root -m 644 /tmp/cms-misc-services/*.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable cms-send-logs
sudo install -o root -g root /tmp/cms-misc-bin/cms_init /

