server {
        listen 8081 default_server;
        listen [::]:8081 default_server;
        root /var/www/html/int;
        server_name _;


        if ($http_x_forwarded_proto = "http") {
                rewrite  ^/(.*)$  https://$host/$1 redirect;
        }
        rewrite ^/([^.]*[^/])$ https://$host/$1/ redirect;
        location ~* ^.*/favicon\.ico$ {
                root /var/www;
                try_files /cms_static/favicon.ico =404;
                expires max;
        }
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
        listen 8082 default_server;
        listen [::]:8082 default_server;
        root /var/www/html/ext;
        server_name _;

        if ($http_x_forwarded_proto = "http") {
                rewrite  ^/(.*)$  https://$host/$1 redirect;
        }
        rewrite ^/([^.]*[^/])$ https://$host/$1/ redirect;
        location ~* ^.*/favicon\.ico$ {
                root /var/www;
                try_files /cms_static/favicon.ico =404;
                expires max;
        }
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
