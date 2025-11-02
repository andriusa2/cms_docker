#!/bin/sh
# Install cms under a pyenv controlled venv.
# Caller can control the following environment variables:
# - CMS_REPOSITORY - which github repository to use to checkout CMS from.
#   Defaults to lmio/cms
# - CMS_TAG - which branch/tag to checkout CMS at.
#   Defaults to lmio_v1.5

set -eux

if [ -z "$CMS_REPOSITORY" ]; then
  CMS_REPOSITORY='lmio/cms'
fi
if [ -z "$CMS_TAG" ]; then
  CMS_TAG='lmio_v1.5'
fi

# Install system dependencies for cms
# See https://cms.readthedocs.io/en/latest/Installation.html#ubuntu
# Notable differences:
# - cgroup-lite is not required on debian - it only ensures that /sys/fs/cgroup
#   is properly mounted. At least on recent debian versions that happens out of
#   the box.
# - No JDK or pascal support.
# - cppreference-doc-en-html is installed manually to behave a bit better when
#   served via webserver.
sudo apt-get install -y \
  build-essential postgresql-client zip \
  libffi-dev libpq-dev libyaml-dev \
  gettext iso-codes shared-mime-info \

# Isolate dependencies
sudo apt-get install -y \
  pkg-config libcap-dev libsystemd-dev

. ~/.pyenv_script

# Now set up and activate venv for it using system python.
# If different version is needed use pyenv install -s <version> and
# pyenv virtualenv -f <version> instead.
/usr/local/lib/pyenv/bin/pyenv virtualenv -f cms-venv
eval "$(/usr/local/lib/pyenv/bin/pyenv sh-activate cms-venv)"

# Put CMS into /usr/local/lib/cms
CMS_PATH='/usr/local/lib/cms'
sudo mkdir -p "${CMS_PATH}"
sudo chown "${USER}" "${CMS_PATH}"
# Pull cms repo and if that fails, attempt to clone.
# This lets the current script to work for "reinstall" use case with minimal
# effort.
git -C "${CMS_PATH}" pull origin "${CMS_TAG}" || git clone \
  --recurse-submodules \
  --branch "${CMS_TAG}" \
  "https://github.com/${CMS_REPOSITORY}.git" "${CMS_PATH}"

# It looks like prerequisites.py at least require being in the same directory.
# TODO - fix that.
cd "$CMS_PATH"
# https://cms.readthedocs.io/en/latest/Installation.html#preparation-steps
# Note that we need to either forward our current PATH to sudo or fully
# qualify the python interpreter to use to avoid using system python here.
# PATH approach breaks any sbin usage, so we get fully qualified python here.
# We are expected to install configs separately, so no point in using example
# ones.
sudo "${VIRTUAL_ENV}/bin/python3" prerequisites.py --no-conf -y install

# Install multiple isolate binaries and systemd unit.
# This probably should be done via isolate deb package instead.
sudo make -C "${CMS_PATH}/isolate" install
sudo install -o root -g root -m 644 "${CMS_PATH}/isolate/*" /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable isolate

# Now install CMS itself
# https://cms.readthedocs.io/en/latest/Installation.html#method-2-virtual-environment
pip3 install -r requirements.txt
python3 setup.py install

# Link CMS static files to /var/www/ as well to serve under nginx.
CMS_EGG_PATH=$( pip3 show cms | grep Location: | cut -f2 -d' ' )
sudo ln -s "${CMS_EGG_PATH}/cms/server/contest/static" "/var/www/cws_static"
sudo ln -s "${CMS_EGG_PATH}/cms/server/admin/static" "/var/www/aws_static"
sudo ln -s "${CMS_EGG_PATH}/cms/server/static" "/var/www/cms_static"
