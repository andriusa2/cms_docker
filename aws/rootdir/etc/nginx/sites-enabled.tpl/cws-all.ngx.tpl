server {
    listen 8080 default_server;
    real_ip_header    X-Forwarded-For;
    set_real_ip_from  VPC_CIDR;
	
    location / { alias /var/www/html/; }

    location /centriukas/ {
        proxy_pass http://127.0.0.1:8889/;
        client_max_body_size 100M;
    }

    location ~ ^/centriukas/static/(.+)$ {
        root /var/www/;
        try_files /aws_static/$1 /cms_static/$1 =404;
        expires 1w;
    }

    location /jau/ {
        proxy_pass http://127.0.0.1:9000/lmio31-1-jau/;
        client_max_body_size 100M;
    }

    location /vyr/ {
        proxy_pass http://127.0.0.1:9000/lmio31-1-vyr/;
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
}
