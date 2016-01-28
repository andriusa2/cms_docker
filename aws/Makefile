GIT_CMS ?= git://github.com/lmio/cms.git -b lmio2015 --recursive

# Since exposing these secrets has very minimal impact on running the Olympiad,
# I opted for simplicity over security here.
ADMINPW ?= default
DBPASSWD ?= default

metadata = curl -s -m 0.1 http://169.254.169.254/latest/meta-data
AMI_ID ?= $(shell $(metadata)/ami-id || echo ami-...)
REGION ?= $(shell $(metadata)/placement/availability-zone | \
		head -c -1 || echo us-east-1)
SECRET_KEY ?= $(shell $(metadata)/hostname | md5sum | awk '{print $$1}')

BUILD_VARS = $(addprefix --build-arg ,ADMINPW=$(ADMINPW) DBPASSWD=$(DBPASSWD))

MAIN_CONF = rootdir/usr/local/etc/cms_main.conf
WORKER_CONF = rootdir/usr/local/etc/cms_worker.conf
CENTRIUKAS_CONF = rootdir/usr/local/etc/cms_centriukas.conf
DEBFILE = build/cms_aws-1_amd64.deb

.PHONY: all deb help get-ami-name

all: deb
deb: $(DEBFILE)

help:
	@echo Usage:
	@echo "    make deb ADMINPW=grok1 DBPASSWD=grok2"
	@echo "    make ami [AMI_ID=$(AMI_ID)] [REGION=$(REGION)]"
	@echo "    make get-ami-name  gets latest ami id of ubuntu 14.04 hvm"

cms:
	git clone $(GIT_CMS)

$(WORKER_CONF): $(MAIN_CONF)
	echo $(SECRET_KEY)
	sed  \
		-e 's/worker4.lmio/0.0.0.0/g' \
		-e 's/SECRET_KEY/$(SECRET_KEY)/' \
		-e '/worker.\.lmio/d' $< > $@

$(CENTRIUKAS_CONF): $(MAIN_CONF)
	sed \
		-e 's/SECRET_KEY/$(SECRET_KEY)/' \
		-e 's/centriukas.lmio/0.0.0.0/g' $< > $@

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

get-ami-name:
	@aws ec2 describe-images \
	    --region eu-central-1 \
	    --owners 099720109477 \
	    --filters \
		Name=root-device-type,Values=ebs \
		Name=architecture,Values=x86_64 \
		Name=name,Values='*hvm-ssd/ubuntu-trusty-14.04*' | \
	    grep \"Name\": | sort | tail -1 | awk -F'"' '{ print $$4 }'
