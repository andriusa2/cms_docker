#!/bin/bash
# Mirrors packer_conf and sets local machine as contest one.
set -eux

# Precreate tmp dirs
mkdir -p /tmp/{cms,cms-misc-bin,cms-misc-services,nginx,supervisor,systemd/resolved.conf.d,www}
# Copy the files to expected tmp places
cp -r rootdir/usr/local/etc/* /tmp/cms/
cp -r send_logs/cmsSendLogs /tmp/cms-misc-bin/
cp -r send_logs/cms-send-logs.service /tmp/cms-misc-services/
cp -r rootdir/etc/nginx/* /tmp/nginx/
cp -r rootdir/etc/supervisor/* /tmp/supervisor/
cp -r rootdir/etc/systemd/resolved.conf.d/* /tmp/systemd/resolved.conf.d/
cp -r rootdir/var/www/* /tmp/www/
cp -r rootdir/cms_init /tmp/cms-misc-bin/cms_init
cp dejavu-fonts-ttf-2.37.zip /tmp/dejavu-fonts.zip
cp html-book-20230810.zip /tmp/cppreference.zip
/bin/bash scripts/00_common_deps.sh
/bin/bash scripts/01_pyenv.sh
/bin/bash scripts/02_cms.sh
/bin/bash scripts/03_configs_and_webserving.sh
/bin/bash scripts/04_helper_binaries.sh
/bin/bash scripts/05_system_configuration.sh
