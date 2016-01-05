GIT_CMS ?= git://github.com/lmio/cms.git -b lmio2015 --recursive

# Change these before running 'make', or run make as follows:
#
# make ADMINPW=grok1 DBPASSWD=grok2
ADMINPW ?= default
DBPASSWD ?= default

BUILD_VARS = $(addprefix --build-arg ,ADMINPW=$(ADMINPW) DBPASSWD=$(DBPASSWD))

.PHONY: all

all: build/cms_aws.deb

cms:
	git clone $(GIT_CMS)

build/cms_aws.deb: cms Dockerfile
	docker build $(BUILD_VARS) -t cms_builder .
	docker run --rm -v $(CURDIR)/build:/build cms_builder

ami:
	:
