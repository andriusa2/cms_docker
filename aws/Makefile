GIT_CMS ?= git://github.com/lmio/cms.git -b lmio2015 --recursive

# Since exposing these secrets has very minimal impact on running the Olympiad,
# I opted for simplicity over security here.
ADMINPW ?= default
DBPASSWD ?= default

metadata = curl -s -m 0.1 http://169.254.169.254/latest/meta-data
AMI_ID ?= $(shell $(metadata)/ami-id || echo ami-...)
REGION ?= $(shell $(metadata)/placement/availability-zone || echo us-east-1)

BUILD_VARS = $(addprefix --build-arg ,ADMINPW=$(ADMINPW) DBPASSWD=$(DBPASSWD))

MAIN_CONF = rootdir/usr/local/etc/cms_main.conf
WORKER_CONF = rootdir/usr/local/etc/cms_worker.conf
CENTRIUKAS_CONF = rootdir/usr/local/etc/cms_centriukas.conf
DEBFILE = build/cms_aws-1_amd64.deb

.PHONY: all deb help

all: deb
deb: $(DEBFILE)

help:
	@echo Usage:
	@echo "    make deb ADMINPW=grok1 DBPASSWD=grok2"
	@echo "    make ami [AMI_ID=$(AMI_ID)] [REGION=$(REGION)]"

cms:
	git clone $(GIT_CMS)

$(WORKER_CONF): $(MAIN_CONF)
	sed -e 's/worker4.lmio/0.0.0.0/g' \
		-e '/worker.\.lmio/d' $< > $@

$(CENTRIUKAS_CONF): $(MAIN_CONF)
	sed 's/centriukas.lmio/0.0.0.0/g' $< > $@

$(DEBFILE): $(WORKER_CONF) $(CENTRIUKAS_CONF) cms Dockerfile
	docker build $(BUILD_VARS) -t cms_aws .
	docker run --rm -v $(CURDIR)/build:/build cms_aws

ami: $(DEBFILE)
	docker run --rm --privileged \
		-v /dev:/dev \
		-v $(CURDIR)/build:/build cms_aws \
		aminate -e ec2_aptitude_linux \
			-B $(AMI_ID) \
			-r $(REGION) \
			--partition 1 \
			--vm-type hvm \
			file:///$<
