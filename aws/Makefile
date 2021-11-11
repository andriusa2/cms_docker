GIT_CMS ?= git://github.com/andriusa2/cms.git -b lmio33-runtime --recursive

# Since exposing these secrets has very minimal impact on running the Olympiad,
# I opted for simplicity over security here. Keep it >8 characters.
DBPASSWD ?= default1
RWSPASSWD ?= default2

metadata = curl -s -m 0.1 http://169.254.169.254/latest/meta-data
REGION ?= $(shell $(metadata)/placement/availability-zone | \
		head -c -1 || echo us-east-1)
VPC_MAC ?= $(shell $(metadata)/network/interfaces/macs/ | head -n1 | tr -d '/')
VPC_CIDR ?= $(shell $(metadata)/network/interfaces/macs/$(VPC_MAC)/vpc-ipv4-cidr-block/)
SECRET_KEY ?= $(shell $(metadata)/instance-id | md5sum | awk '{print $$1}')

BUILD_VARS = $(addprefix --build-arg ,DBPASSWD=$(DBPASSWD) RWSPASSWD=$(RWSPASSWD))

NGINX_SITES_TPL_DIR := rootdir/etc/nginx/sites-enabled.tpl
NGINX_SITES_DIR := rootdir/etc/nginx/sites-enabled
NGINX_SITES_TPL := $(subst .tpl,,$(notdir $(wildcard $(NGINX_SITES_TPL_DIR)/*.tpl)))
NGINX_SITES := $(addprefix $(NGINX_SITES_DIR)/,$(NGINX_SITES_TPL))
MAIN_TPL = cms.conf.tpl
MAIN_CONF = rootdir/usr/local/etc/cms_main.conf
WORKER_CONF = rootdir/usr/local/etc/cms_worker.conf
CENTRIUKAS_CONF = rootdir/usr/local/etc/cms_centriukas.conf
DEBFILE = build/cms_aws-1_amd64.deb
PACKER_CONF = packer_conf.json
PACKER_UPDATE_CONF = packer_update_conf.json

.PHONY: ami deb help

help:
	@echo Usage:
	@echo "    make deb RWSPASSWD=grok1 DBPASSWD=grok2 [SECRET_KEY=$(SECRET_KEY)]"
	@echo "    sudo make ami"

deb: $(DEBFILE)

cms:
	git clone $(GIT_CMS)

$(NGINX_SITES_DIR)/%: $(NGINX_SITES_TPL_DIR)/%.tpl
	mkdir -p rootdir/etc/nginx/sites-enabled
	sed -e 's;VPC_CIDR;$(VPC_CIDR);' $< > $@

$(MAIN_CONF): $(MAIN_TPL) $(NGINX_SITES)
	mkdir -p rootdir/usr/local/etc
	sed \
		-e 's/SECRET_KEY/$(SECRET_KEY)/' -e 's/RWSPASSWD/$(RWSPASSWD)/' $< > $@

$(WORKER_CONF): $(MAIN_CONF)
	sed  \
		-e 's/worker9.lmio/0.0.0.0/g' \
		-e '/worker.\.lmio/d' $< > $@

$(CENTRIUKAS_CONF): $(MAIN_CONF)
	sed \
		-e 's/centriukas.lmio/0.0.0.0/g' $< > $@

$(DEBFILE): $(WORKER_CONF) $(CENTRIUKAS_CONF) cms Dockerfile
	docker build $(BUILD_VARS) -t cms_aws .
	docker run --rm -v $(CURDIR)/build:/build cms_aws

# Installs packer. Ideally this should go through package manager,
# but for now this will have to do.
packer:
	curl -o packer.zip https://releases.hashicorp.com/packer/1.4.5/packer_1.4.5_linux_amd64.zip
	unzip -q packer.zip
	rm packer.zip

# This needs to be run as root because packer will try to mount new volume.
ami: $(DEBFILE) $(PACKER_CONF) packer
	./packer validate -var 'debfile=$(DEBFILE)' $(PACKER_CONF)
	./packer build -var 'debfile=$(DEBFILE)' $(PACKER_CONF)

update-ami: $(DEBFILE) $(PACKER_UPDATE_CONF) packer
	./packer validate -var 'debfile=$(DEBFILE)' $(PACKER_UPDATE_CONF)
	./packer build -var 'debfile=$(DEBFILE)' $(PACKER_UPDATE_CONF)
