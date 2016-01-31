GIT_CMS ?= git://github.com/lmio/cms.git -b lmio2015 --recursive

# Since exposing these secrets has very minimal impact on running the Olympiad,
# I opted for simplicity over security here.
ADMINPW ?= default
DBPASSWD ?= default

metadata = curl -s -m 0.1 http://169.254.169.254/latest/meta-data
REGION ?= $(shell $(metadata)/placement/availability-zone | \
		head -c -1 || echo us-east-1)
SECRET_KEY ?= $(shell $(metadata)/instance-id | md5sum | awk '{print $$1}')

BUILD_VARS = $(addprefix --build-arg ,ADMINPW=$(ADMINPW) DBPASSWD=$(DBPASSWD))

MAIN_TPL = cms.conf.tpl
MAIN_CONF = rootdir/usr/local/etc/cms_main.conf
WORKER_CONF = rootdir/usr/local/etc/cms_worker.conf
CENTRIUKAS_CONF = rootdir/usr/local/etc/cms_centriukas.conf
DEBFILE = build/cms_aws-1_amd64.deb

.PHONY: all deb help

-include config.mk

help:
	@echo Usage:
	@echo "    make deb ADMINPW=grok1 DBPASSWD=grok2"
	@echo "    make ami [AMI_ID=$(AMI_ID)] [REGION=$(REGION)] [SECRET_KEY=$(SECRET_KEY)]"

deb: $(DEBFILE)

cms:
	git clone $(GIT_CMS)

$(MAIN_CONF): $(MAIN_TPL)
	mkdir -p rootdir/usr/local/etc
	sed \
		-e 's/SECRET_KEY/$(SECRET_KEY)/' $< > $@

$(WORKER_CONF): $(MAIN_CONF)
	sed  \
		-e 's/worker4.lmio/0.0.0.0/g' \
		-e '/worker.\.lmio/d' $< > $@

$(CENTRIUKAS_CONF): $(MAIN_CONF)
	sed \
		-e 's/centriukas.lmio/0.0.0.0/g' $< > $@

$(DEBFILE): $(WORKER_CONF) $(CENTRIUKAS_CONF) cms Dockerfile
	docker build $(BUILD_VARS) -t cms_aws .
	docker run --rm -v $(CURDIR)/build:/build cms_aws

ami: config.mk $(DEBFILE)
	docker run --rm --privileged \
		-v /dev:/dev \
		-v $(CURDIR)/build:/build cms_aws \
		aminate -e ec2_aptitude_linux \
			-B $(AMI_ID) \
			-r $(REGION) \
			--partition 1 \
			--vm-type hvm \
			file:///$(DEBFILE)

config.mk:
	aws ec2 describe-images \
	    --output text \
	    --region eu-central-1 \
	    --owners 099720109477 \
	    --filters \
		Name=root-device-type,Values=ebs \
		Name=architecture,Values=x86_64 \
		Name=name,Values='*hvm-ssd/ubuntu-trusty-14.04*' | \
	grep ^IMAGES | sort -k6,6 | \
	awk 'END { print "AMI_ID="$$5; print "AMI_NAME="$$6}' > $@
