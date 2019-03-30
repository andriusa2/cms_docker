server {
    listen 8085 default_server;
    real_ip_header    X-Forwarded-For;
    set_real_ip_from  VPC_CIDR;
    proxy_buffering off;	
    absolute_redirect off;

    location = /leaderboard/jau/ {
        rewrite $ Ranking.html redirect;
    }
    location = /leaderboard/vyr/ {
        rewrite $ Ranking.html redirect;
    }
    location = /leaderboard/vyr-eng/ {
        rewrite $ Ranking.html redirect;
    }
    location /leaderboard/jau/ {
        proxy_pass http://127.0.0.1:8890/;
        client_max_body_size 100M;
    }

    location /leaderboard/vyr/ {
        proxy_pass http://127.0.0.1:8891/;
        client_max_body_size 100M;
    }

    location /leaderboard/vyr-eng/ {
        proxy_pass http://127.0.0.1:8892/;
        client_max_body_size 100M;
    }
}
