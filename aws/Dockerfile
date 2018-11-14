FROM debian:9

RUN apt-get update
RUN apt-get -y install gettext python2.7 python-setuptools \
                       checkinstall apache2-utils git unzip

# We can reuse this image for aminating too
# NB - debian requires cloud-utils for growpart
RUN apt-get -y install python-dev python-yaml python-pip \
                       cloud-utils
RUN pip install \
        git+https://github.com/Netflix/aminator.git#egg=aminator

ADD cms /cms/
WORKDIR /cms/

RUN make build

RUN echo 'Contest Management System, LMIO2018 version' > description-pak
RUN checkinstall -y --install=no \
        --exclude ${PWD},/etc,/var \
        --pkgversion="`date +'%Y%m%d-%H%M'`" \
        --requires \
fp-compiler,postgresql-client,gettext,python2.7,python-setuptools,\
python-tornado,python-psycopg2,python-sqlalchemy,python-psutil,\
python-netifaces,python-crypto,python-tz,python-six,iso-codes,\
shared-mime-info,stl-manual,python-beautifulsoup,python-mechanize,\
python-coverage,python-mock,cgroup-tools,python-requests,\
python-werkzeug,python-gevent,python-yaml,python-sphinx,supervisor,\
nginx,patool,htop,python-pip,python-bcrypt \
       make install

RUN dpkg-deb -R cms_*.deb unpacked_deb
RUN mkdir -p unpacked_deb/usr/share/doc && \
    curl -O http://olimp.mif.vu.lt/files/doc/dokumentacijos_rinkinys.zip && \
    unzip -q dokumentacijos_rinkinys.zip -d unpacked_deb/usr/share/doc/ && \
    rm dokumentacijos_rinkinys.zip && \
    chmod -R u+rwX,go=rX unpacked_deb/usr/share/doc
    
RUN pip install --root unpacked_deb -I boto3
RUN chmod 755       unpacked_deb/usr/local/bin/isolate && \
    chown root:root unpacked_deb/usr/local/bin/isolate && \
    chmod +s        unpacked_deb/usr/local/bin/isolate

ADD rootdir/ unpacked_deb/

RUN chmod 755       unpacked_deb/usr/local/bin/send_logs && \
    chown root:root unpacked_deb/usr/local/bin/send_logs && \
    chmod +s        unpacked_deb/usr/local/bin/send_logs && \
    mkdir -p unpacked_deb/etc/rc0.d/ && \
    ln -sf /usr/local/bin/send_logs unpacked_deb/etc/rc0.d/S01sendLogs && \
    rm -r unpacked_deb/etc/nginx/sites-enabled.tpl/

ARG DBPASSWD
ENV DBPASSWD $DBPASSWD
RUN sed -i "s/DBPASSWD/${DBPASSWD}/" unpacked_deb/usr/local/etc/cms_*.conf && \
    rm unpacked_deb/usr/local/etc/cms.conf
ARG RWSPASSWD
ENV RWSPASSWD $RWSPASSWD
RUN sed -i "s/RWSPASSWD/${RWSPASSWD}/" unpacked_deb/usr/local/etc/rws-*.conf

RUN mkdir -p  unpacked_deb/var/local/cache/cms && \
    mkdir -p  unpacked_deb/var/local/log/cms   && \
    mkdir -p  unpacked_deb/var/local/lib/cms   && \
    mkdir -p  unpacked_deb/var/local/lib/cms/jau && \
    mkdir -p  unpacked_deb/var/local/lib/cms/vyr && \
    mkdir -p  unpacked_deb/var/local/lib/cms/vyreng && \
    chmod 777 unpacked_deb/var/local/cache/cms && \
    chmod 777 unpacked_deb/var/local/log/cms   && \
    chmod 777 unpacked_deb/var/local/lib/cms   && \
    chmod 777 unpacked_deb/var/local/lib/cms/jau && \
    chmod 777 unpacked_deb/var/local/lib/cms/vyr && \
    chmod 777 unpacked_deb/var/local/lib/cms/vyreng && \
    chmod 755 unpacked_deb/DEBIAN/preinst      && \
    chmod 755 unpacked_deb/DEBIAN/postinst     && \
    chmod 755 unpacked_deb/DEBIAN/postrm

RUN ln -sf /usr/share/zoneinfo/Europe/Vilnius unpacked_deb/etc/localtime
RUN test -e unpacked_deb/usr/local/lib/python2.7/dist-packages/cms-1.3.2-py2.7.egg/cms/server/contest/static && \
    test -e unpacked_deb/usr/local/lib/python2.7/dist-packages/cms-1.3.2-py2.7.egg/cms/server/admin/static && \
    test -e unpacked_deb/usr/local/lib/python2.7/dist-packages/cms-1.3.2-py2.7.egg/cms/server/static && \
    mkdir -p unpacked_deb/var/www/ && \ 
    ln -sf /usr/local/lib/python2.7/dist-packages/cms-1.3.2-py2.7.egg/cms/server/contest/static unpacked_deb/var/www/cws_static && \
    ln -sf /usr/local/lib/python2.7/dist-packages/cms-1.3.2-py2.7.egg/cms/server/admin/static unpacked_deb/var/www/aws_static && \
    ln -sf /usr/local/lib/python2.7/dist-packages/cms-1.3.2-py2.7.egg/cms/server/static unpacked_deb/var/www/cms_static

RUN dpkg-deb -b unpacked_deb cms_aws-1_amd64.deb

CMD cp cms_aws-1_amd64.deb /build/cms_aws-1_amd64.deb
