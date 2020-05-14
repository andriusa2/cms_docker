server {
    listen 8080 default_server;
    real_ip_header    X-Forwarded-For;
    set_real_ip_from  VPC_CIDR;
    set_real_ip_from  127.0.0.1/32;
    absolute_redirect off;
	
    location / {
        proxy_pass http://127.0.0.1:8081;
    }

    location /centriukas/ {
        proxy_pass http://127.0.0.1:8889/;
        client_max_body_size 100M;
    }

    location ~* ^.*/favicon\.ico$ {
        root /var/www;
        try_files /cms_static/favicon.ico =404;
        expires 1w;
    }

    location ~ ^/centriukas/static/(.+)$ {
        root /var/www/;
        try_files /aws_static/$1 /cms_static/$1 =404;
        expires 1w;
    }

    location /jau/ {
        proxy_pass http://127.0.0.1:9000/;
        client_max_body_size 100M;
    }

    location /vyr/ {
        proxy_pass http://127.0.0.1:9001/;
        client_max_body_size 100M;
    }

    location /vyr-eng/ {
        proxy_pass http://127.0.0.1:9002/;
        client_max_body_size 100M;
    }

    location /test/jau/ {
        proxy_pass http://127.0.0.1:9003/;
        client_max_body_size 100M;
    }

    location /test/vyr/ {
        proxy_pass http://127.0.0.1:9004/;
        client_max_body_size 100M;
    }

    location /test/vyr-eng/ {
        proxy_pass http://127.0.0.1:9005/;
        client_max_body_size 100M;
    }

    location /mok/ {
        proxy_pass http://127.0.0.1:8890/;
        client_max_body_size 100M;
    }

    location ~ ^/(?:test/)?(?:jau|vyr|vyr-eng|mok)/static/(.+)$ {
        root /var/www/;
        try_files /cws_static/$1 /cms_static/$1 =404;
        expires 1w;
    }

    location ~ ^/(?:test/)?(?:jau|vyr|vyr-eng|mok)/favicon.ico$ {
        root /var/www/;
        try_files /cms_static/favicon.ico =404;
        expires 1w;
    }

    # More hacks for cppreference/mwiki
    rewrite ^(/(?:test/)?(?:jau|vyr|vyr-eng|mok))/stl/en/cpp.*/http.+$ $1/documentation redirect;

    location ~ ^/(?:test/)?(?:jau|vyr|vyr-eng|mok)/stl/.*mwiki {
        return 410;
        expires max;
    }
}
