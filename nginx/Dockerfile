FROM ubuntu:trusty
MAINTAINER "Motiejus Jakštys" <desired.mta@gmail.com>
RUN apt-get update && apt-get -y install software-properties-common && \
    add-apt-repository -y ppa:nginx/development && apt-get update && \
    apt-get install -y nginx
ADD lmio.ngx /etc/nginx/sites-enabled/
ADD index.html /var/www/html/
ADD htpasswd /etc/nginx/htpasswd
RUN rm /etc/nginx/sites-enabled/default

RUN echo "daemon off; error_log /dev/stdout;" >> /etc/nginx/nginx.conf
EXPOSE 80
CMD /usr/sbin/nginx
