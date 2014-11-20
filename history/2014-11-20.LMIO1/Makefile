.PHONY: all clean

all: admin.run cms.run graphite.run cws.run

cms_conf.txt: cms.conf
	{ \
		echo "#!/bin/bash"; \
		echo "set -euo pipefail"; \
		echo "cat > /home/core/cms.conf <<EOF"; \
	} > $@
	cat $< >> $@
	echo EOF >> $@

admin.run: cms_conf.txt init_db.txt cms.service graphite-write.service
	cat $^ > $@

cms.run: cms_conf.txt cms.service graphite-write.service
	cat $^ > $@

cws.run: cms_conf.txt cms_nginx.service cws.service graphite-write.service
	cat $^ > $@

graphite.run: graphite.service graphite-write.service
	cat $^ > $@

clean:
	rm -f cms.run admin.run graphite.run cms_conf.txt
