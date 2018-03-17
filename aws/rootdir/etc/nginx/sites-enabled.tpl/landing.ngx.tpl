server {
        listen 80 default_server;
        listen [::]:80 default_server;
        root /var/www/html/int;
        server_name _;


        if ($http_x_forwarded_proto = "http") {
                rewrite  ^/(.*)$  https://$host/$1 redirect;
        }
        rewrite ^/([^.]*[^/])$ https://$host/$1/ redirect;
        location ~* \.(jpg|jpeg|gif|png|css|js|ico|xml)$ {
                try_files $uri =404;
                expires max;
        }
        location = / {
                try_files /index.html =404;
        }
        # cppreference hack
        location /mwiki {
                return 200;
                expires max;
        }
        location / {
                rewrite ^/(.*)$ https://$host/ redirect;
        }
}
server {
        listen 81 default_server;
        listen [::]:81 default_server;
        root /var/www/html/ext;
        server_name _;

        if ($http_x_forwarded_proto = "http") {
                rewrite  ^/(.*)$  https://$host/$1 redirect;
        }
        rewrite ^/([^.]*[^/])$ https://$host/$1/ redirect;
        location ~* \.(jpg|jpeg|gif|png|css|js|ico|xml)$ {
                try_files $uri =404;
                expires max;
        }
        location = / {
                try_files /index.html =404;
        }
        # cppreference hack
        location /mwiki {
                return 200;
                expires max;
        }
        location / {
                rewrite ^/(.*)$ https://$host/ redirect;
        }
}