.PHONY: all clean

all: cms.run graphite.run cws.run

cms_conf.txt: cms.conf
	{ \
		echo "#!/bin/bash"; \
		echo "set -euo pipefail"; \
		echo "cat > /home/core/cms.conf <<EOF"; \
	} > $@
	cat $< >> $@
	echo EOF >> $@

cms.run: cms_conf.txt cms.service graphite-write.service
	cat $^ > $@

cws.run: cms_conf.txt cws.service graphite-write.service
	cat $^ > $@

graphite.run: graphite.service graphite-write.service
	cat $^ > $@

clean:
	rm -f cms.run admin.run graphite.run cms_conf.txt
