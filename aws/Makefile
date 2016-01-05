GIT_CMS ?= git://github.com/lmio/cms.git -b lmio2015 --recursive

.PHONY: deb all

all: deb

DEB = 

cms:
	git clone $(GIT_CMS)

deb: build/cms.deb

build/cms.deb: cms Dockerfile
	docker build -t cms_builder .
	docker run --rm -v $(CURDIR)/build:/build cms_builder
