FROM ubuntu:14.04

RUN apt-get update
RUN apt-get -y install gettext python2.7 python-setuptools \
                       checkinstall apache2-utils

ADD cms /cms/
WORKDIR /cms/

RUN ./setup.py build

RUN echo 'Contest Management System, LMIO2015 version' > description-pak
RUN checkinstall -y --install=no \
        --exclude ${PWD},/etc,/var \
        --requires \
            fpc,postgresql-client,gettext,python2.7,python-setuptools,\
python-tornado,python-psycopg2,python-sqlalchemy,python-psutil,\
python-netifaces,python-crypto,python-tz,python-six,iso-codes,\
shared-mime-info,stl-manual,python-beautifulsoup,python-mechanize,\
python-coverage,python-mock,cgroup-lite,python-requests,\
python-werkzeug,python-gevent,python-yaml,python-sphinx \
       ./setup.py install

RUN dpkg-deb -R cms_*.deb unpacked_deb
RUN chmod 755       unpacked_deb/usr/local/bin/isolate && \
    chown root:root unpacked_deb/usr/local/bin/isolate && \
    chmod +s        unpacked_deb/usr/local/bin/isolate

ADD rootdir/ unpacked_deb/

ARG ADMINPW
ENV ADMINPW $ADMINPW
RUN htpasswd -bc unpacked_deb/etc/nginx/htpasswd lioadmin ${ADMINPW}

ARG DBPASSWD
ENV DBPASSWD $DBPASSWD
RUN sed -i "s/DBPASSWD/${DBPASSWD}/" unpacked_deb/usr/local/etc/cms.conf

RUN dpkg-deb -b unpacked_deb cms_aws.deb

CMD cp cms_aws.deb /build/cms_aws.deb
