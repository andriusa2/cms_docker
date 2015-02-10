.PHONY: all clean

all: cms.run cws.run

cms_conf.txt: cms.conf
	{ \
		echo "#!/bin/bash"; \
		echo "set -euo pipefail"; \
		echo "cat > /home/core/cms.conf <<EOF"; \
	} > $@
	cat $< >> $@
	echo EOF >> $@

cms.run: cms_conf.txt authorized_keys.service cms.service
	cat $^ > $@

cws.run: cms_conf.txt authorized_keys.service cws.service
	cat $^ > $@

clean:
	rm -f cms.run admin.run cms_conf.txt
