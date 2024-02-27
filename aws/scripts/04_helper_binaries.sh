#!/bin/bash
# Install a suite of helper binaries for automation/logging purposes.
# All executables put to /tmp/cms-misc-bin will be installed into
# /usr/local/bin.
# All services put to /tmp/cms-misc-services will be installed as system
# services.
set -eux

# Set up venv with required dependencies.
# Note that because we don't care about version and just use system, we
# use normal venv, but drop it in pyenv version list
sudo apt-get -y install python3-pip python3-venv

. ~/.pyenv_script
python3 -m venv /usr/local/lib/pyenv/versions/aws-automation
eval "$(/usr/local/lib/pyenv/bin/pyenv sh-activate aws-automation)"
pip3 install boto3 ec2-metadata psycopg2 requests

# Adjust python shebangs to venv python
# TODO - this normally should be done via setuptools, so fix that.
sed -s -i -e 'sT#!/usr/bin/env python3T#!'"${VIRTUAL_ENV}/bin/python3T" /tmp/cms-misc-bin/*
sudo install -o root -g root -m 755 /tmp/cms-misc-bin/* /usr/local/bin
sudo install -o root -g root -m 644 /tmp/cms-misc-services/*.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable cms-send-logs
sudo install -o root -g root /tmp/cms-misc-bin/cms_init /

