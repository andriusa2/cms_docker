GIT_CMS ?= git://github.com/lmio/cms.git -b lmio2015 --recursive

# Change these before running 'make', or run make as follows:
#
# make ADMINPW=grok1 DBPASSWD=grok2
ADMINPW ?= default
DBPASSWD ?= default

BUILD_VARS = $(addprefix --build-arg ,ADMINPW=$(ADMINPW) DBPASSWD=$(DBPASSWD))

MAIN_CONF = rootdir/usr/local/etc/cms_main.conf
WORKER_CONF = rootdir/usr/local/etc/cms_worker.conf

.PHONY: all

all: deb
deb: build/cms_aws.deb

cms:
	git clone $(GIT_CMS)

$(WORKER_CONF): $(MAIN_CONF)
	sed -e 's/worker4.cms1/127.0.0.1/g' \
		-e '/worker.\.cms1/d' $< > $@

build/cms_aws.deb: $(WORKER_CONF) cms Dockerfile
	docker build $(BUILD_VARS) -t cms_builder .
	docker run --rm -v $(CURDIR)/build:/build cms_builder

ami:
	:
