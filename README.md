Docker image and scripts for CMS
--------------------------------

This repository contains Docker image, helper scripts, tips and tricks for
[Contest Management System][CMS].

How to run this
---------------

First, configure `cms.conf` and `cms.ranking.conf` to reflect your environment.
Then, start the containers:

```
$ docker build -t motiejus/cms_docker:v1.1.0 . # optional
$ docker run --privileged -ti \
	-v ${PWD}/cms.conf.sample:/etc/cms.conf \
	-v ${PWD}/cms.ranking.conf.sample:/etc/cms.ranking.conf \
	motiejus/cms_docker:v1.1.0

```

[CMS]: http://cms-dev.github.io/
