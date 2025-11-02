# Private
server {
    listen 8085 default_server;
    real_ip_header    X-Forwarded-For;
    set_real_ip_from  VPC_CIDR;
    proxy_buffering off;	
    absolute_redirect off;

    auth_basic "lmio very secret";
    auth_basic_user_file /etc/nginx/rwspriv.htpasswd;

    location = /jau {
        rewrite $ jau/ redirect;
    }
    location = /vyr {
        rewrite $ vyr/ redirect;
    }
    location = /jau/Ranking.html {
        rewrite Ranking\.html$ . redirect;
    }
    location = /vyr/Ranking.html {
        rewrite Ranking\.html$ . redirect;
    }
    location /jau/ {
        proxy_pass http://127.0.0.1:8890/;
        client_max_body_size 100M;
    }
    location /vyr/ {
        proxy_pass http://127.0.0.1:8891/;
        client_max_body_size 100M;
    }
    location / {
        return 404;
    }
}
# Public
server {
    listen 8086 default_server;
    real_ip_header    X-Forwarded-For;
    set_real_ip_from  VPC_CIDR;
    proxy_buffering off;
    absolute_redirect off;

    auth_basic "lmio secret";
    auth_basic_user_file /etc/nginx/rwspub.htpasswd;

    location = /jau {
        rewrite $ jau/ redirect;
    }
    location = /vyr {
        rewrite $ vyr/ redirect;
    }
    location = /jau/Ranking.html {
        rewrite Ranking\.html$ . redirect;
    }
    location = /vyr/Ranking.html {
        rewrite Ranking\.html$ . redirect;
    }
    location /jau/ {
        proxy_pass http://127.0.0.1:8892/;
        client_max_body_size 100M;
    }
    location /vyr/ {
        proxy_pass http://127.0.0.1:8893/;
        client_max_body_size 100M;
    }
    location / {
        return 404;
    }
}
