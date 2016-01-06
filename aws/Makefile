GIT_CMS ?= git://github.com/lmio/cms.git -b lmio2015 --recursive

# Change these before running 'make', or run make as follows:
#
# make ADMINPW=grok1 DBPASSWD=grok2
ADMINPW ?= default
DBPASSWD ?= default

BUILD_VARS = $(addprefix --build-arg ,ADMINPW=$(ADMINPW) DBPASSWD=$(DBPASSWD))

MAIN_CONF = rootdir/usr/local/etc/cms_main.conf
WORKER_CONF = rootdir/usr/local/etc/cms_worker.conf

.PHONY: all deb help

metadata = curl -s http://169.254.169.254/latest/meta-data
az = $(shell $(metadata)/placement/availability-zone | head -c -1)
ami = $(shell $(metadata)/ami-id)

DEBFILE = build/cms_aws-1_amd64.deb

all: deb
deb: $(DEBFILE)

help:
	@echo Usage: make deb ADMINPW=grok1 DBPASSWD=grok2

cms:
	git clone $(GIT_CMS)

$(WORKER_CONF): $(MAIN_CONF)
	sed -e 's/worker4.lmio/0.0.0.0/g' \
		-e '/worker.\.lmio/d' $< > $@

$(DEBFILE): $(WORKER_CONF) cms Dockerfile
	docker build $(BUILD_VARS) -t cms_aws .
	docker run --rm -v $(CURDIR)/build:/build cms_aws

ami: $(DEBFILE)
	docker run --rm --privileged \
		-v /dev:/dev \
		-v $(CURDIR)/build:/build cms_aws \
		aminate -e ec2_aptitude_linux \
			-B $(ami) \
			-r $(az) \
			--partition 1 \
			--vm-type hvm \
			file:///$<
