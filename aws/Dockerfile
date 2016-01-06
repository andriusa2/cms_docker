FROM ubuntu:14.04

RUN apt-get update
RUN apt-get -y install gettext python2.7 python-setuptools \
                       checkinstall apache2-utils git

# We can reuse this image for aminating too
RUN apt-get -y install python-dev python-yaml
RUN easy_install \
        git+https://github.com/Netflix/aminator.git@2.1.77-dev#egg=aminator

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
python-werkzeug,python-gevent,python-yaml,python-sphinx,supervisor,\
nginx,patool \
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
RUN sed -i "s/DBPASSWD/${DBPASSWD}/" unpacked_deb/usr/local/etc/cms_*.conf && \
    rm unpacked_deb/usr/local/etc/cms.conf
RUN mkdir -p  unpacked_deb/var/local/cache/cms && \
    mkdir -p  unpacked_deb/var/local/log/cms   && \
    chmod 777 unpacked_deb/var/local/cache/cms && \
    chmod 777 unpacked_deb/var/local/log/cms

RUN dpkg-deb -b unpacked_deb cms_aws-1_amd64.deb

CMD cp cms_aws-1_amd64.deb /build/cms_aws-1_amd64.deb
