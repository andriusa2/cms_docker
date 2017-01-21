server {
    listen 8080 default_server;
    real_ip_header    X-Forwarded-For;
    set_real_ip_from  VPC_CIDR;
	
    location / { alias /var/www/html/; }

    location /centriukas/ {
        auth_basic "Restricted";
        auth_basic_user_file /etc/nginx/htpasswd;
        proxy_pass http://127.0.0.1:8889/;
        client_max_body_size 100M;
    }

    location /jau/ {
        auth_basic "Restricted";
        auth_basic_user_file /etc/nginx/htpasswd;
        proxy_pass http://127.0.0.1:9000/;
        client_max_body_size 100M;
    }

    location /vyr/ {
        auth_basic "Restricted";
        auth_basic_user_file /etc/nginx/htpasswd;
        proxy_pass http://127.0.0.1:9001/;
        client_max_body_size 100M;
    }

    location /vyr-eng/ {
        auth_basic "Restricted";
        auth_basic_user_file /etc/nginx/htpasswd;
        proxy_pass http://127.0.0.1:9002/;
        client_max_body_size 100M;
    }

    location /mok/ {
        proxy_pass http://127.0.0.1:8890/;
        client_max_body_size 100M;
    }
}
