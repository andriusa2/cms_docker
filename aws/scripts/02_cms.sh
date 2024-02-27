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
  libcap-dev \
  libffi-dev libpq-dev libyaml-dev \
  gettext iso-codes shared-mime-info

# Set up pyenv controlled py3.9 version, cms has dependencies which can't run
# on py3.10+.
# NB - this picks the latest 3.9 prefixed release, see $ pyenv latest -k 3.9.
/usr/local/lib/pyenv/bin/pyenv install -s 3.9

# Now set up and activate venv for it
/usr/local/lib/pyenv/bin/pyenv virtualenv 3.9 cms-venv
eval "$(/usr/local/lib/pyenv/bin/pyenv sh-activate cms-venv)"

# Put CMS into /usr/local/lib/cms
CMS_PATH='/usr/local/lib/cms'
sudo mkdir -p "${CMS_PATH}"
sudo chown "${USER}" "${CMS_PATH}"
git clone \
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

# Now install CMS itself
# https://cms.readthedocs.io/en/latest/Installation.html#method-2-virtual-environment
export SETUPTOOLS_USE_DISTUTILS="stdlib"
pip3 install -r requirements.txt
python3 setup.py install

# Link CMS static files to /var/www/ as well to serve under nginx.
CMS_EGG_PATH=$( pip3 show cms | grep Location: | cut -f2 -d' ' )
sudo ln -s "${CMS_EGG_PATH}/cms/server/contest/static" "/var/www/cws_static"
sudo ln -s "${CMS_EGG_PATH}/cms/server/admin/static" "/var/www/aws_static"
sudo ln -s "${CMS_EGG_PATH}/cms/server/static" "/var/www/cms_static"

# Link binaries to /usr/local/bin
for bin in "${VIRTUAL_ENV}"/bin/cms*
do
  sudo ln -s "${bin}" /usr/local/bin/
done
