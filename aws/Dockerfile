FROM debian:buster-backports

RUN apt-get update
RUN apt-get -y install gettext python3 python3-setuptools \
                       checkinstall apache2-utils git unzip

# We can reuse this image for aminating too
# NB - debian requires cloud-utils for growpart
RUN apt-get -y install python3-pip cloud-utils libcap-dev python3-future python3-babel
ADD cms /cms/
WORKDIR /cms/

RUN make build

RUN echo 'Contest Management System, LMIO2019 version' > description-pak
RUN checkinstall -y --install=no \
        --exclude ${PWD},/etc,/var \
        --pkgversion="`date +'%Y%m%d-%H%M'`" \
        --requires \
fp-compiler,postgresql-client,gettext,python3,python3-setuptools,\
python3-tornado,python3-psycopg2,python3-sqlalchemy,python3-psutil,\
python3-netifaces,python3-crypto,python3-tz,python3-six,iso-codes,\
shared-mime-info,\
python3-coverage,python3-mock,cgroup-tools,python3-requests,\
python3-werkzeug,python3-gevent,python3-yaml,python3-sphinx,supervisor,\
nginx,patool,htop,python3-pip,python3-bcrypt,python3-xdg,libffi-dev,\
libyaml-dev,libpq-dev,libcap-dev,python3-future,python3-babel \
       make install

RUN dpkg-deb -R cms_*.deb unpacked_deb
RUN mkdir -p unpacked_deb/usr/share/doc && \
    curl -O http://olimp.mif.vu.lt/files/doc/dokumentacijos_rinkinys.zip && \
    unzip -q dokumentacijos_rinkinys.zip -d unpacked_deb/usr/share/doc/ && \
    rm dokumentacijos_rinkinys.zip && \
    chmod -R u+rwX,go=rX unpacked_deb/usr/share/doc

RUN curl -L -O https://github.com/dejavu-fonts/dejavu-fonts/releases/download/version_2_37/dejavu-fonts-ttf-2.37.zip && \
    mkdir -p tmp-fonts && \
    unzip -q dejavu-fonts-ttf-2.37.zip -d tmp-fonts/ && \
    mv tmp-fonts/dejavu-fonts-ttf-2.37/ttf/* unpacked_deb/usr/share/doc/cppreference/ && \
    rm -rf dejavu-fonts-ttf-2.37.zip tmp-fonts && \
    chmod -R u+rwX,go=rX unpacked_deb/usr/share/doc

RUN pip3 install --root unpacked_deb -I boto3 beautifulsoup4
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
RUN test -e unpacked_deb/usr/local/lib/python3*/dist-packages/cms-*.egg/cms/server/contest/static && \
    test -e unpacked_deb/usr/local/lib/python3*/dist-packages/cms-*.egg/cms/server/admin/static && \
    test -e unpacked_deb/usr/local/lib/python3*/dist-packages/cms-*.egg/cms/server/static && \
    mkdir -p unpacked_deb/var/www/ && \ 
    ln -sf /usr/local/lib/python3*/dist-packages/cms-*.egg/cms/server/contest/static unpacked_deb/var/www/cws_static && \
    ln -sf /usr/local/lib/python3*/dist-packages/cms-*.egg/cms/server/admin/static unpacked_deb/var/www/aws_static && \
    ln -sf /usr/local/lib/python3*/dist-packages/cms-*.egg/cms/server/static unpacked_deb/var/www/cms_static

RUN dpkg-deb -b unpacked_deb cms_aws-1_amd64.deb

CMD cp cms_aws-1_amd64.deb /build/cms_aws-1_amd64.deb
