server {
    listen 8085 default_server;
    real_ip_header    X-Forwarded-For;
    set_real_ip_from  VPC_CIDR;
    proxy_buffering off;	

    location /jau/ {
        proxy_pass http://127.0.0.1:8890/;
        client_max_body_size 100M;
    }

    location /vyr/ {
        proxy_pass http://127.0.0.1:8891/;
        client_max_body_size 100M;
    }

    location /vyr-eng/ {
        proxy_pass http://127.0.0.1:8892/;
        client_max_body_size 100M;
    }
}
