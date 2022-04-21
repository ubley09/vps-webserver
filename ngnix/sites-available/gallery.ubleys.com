# Virtual Host configuration for gallery.ubleys.com

server {
    listen 80;
    listen [::]:80;

    location /.well-known/acme-challenge/ {
          root /var/www/gallery.ubleys.com;
    }

    server_name gallery.ubleys.com www.gallery.ubleys.com;
    server_tokens off;

    location / {
           return 301 https://gallery.ubleys.com$request_uri;
    }
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;

    server_name gallery.ubleys.com;

    ssl_certificate /etc/nginx/ssl/live/gallery.ubleys.com/fullchain.pem;
    ssl_certificate_key /etc/nginx/ssl/live/gallery.ubleys.com/privkey.pem;

    root /var/www/gallery.ubleys.com/src;
    index index.php index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass php_service:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
    }
}
