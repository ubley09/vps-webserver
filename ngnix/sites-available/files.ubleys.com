# Virtual Host configuration for files.ubleys.com

server {
    listen 80;
    listen [::]:80;

    location /.well-known/acme-challenge/ {
          root /var/www/files.ubleys.com;
    }

    server_name files.ubleys.com www.files.ubleys.com;
    server_tokens off;

    location / {
           return 301 https://files.ubleys.com$request_uri;
    }
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;

    server_name files.ubleys.com;

    ssl_certificate /etc/nginx/ssl/live/files.ubleys.com/fullchain.pem;
    ssl_certificate_key /etc/nginx/ssl/live/files.ubleys.com/privkey.pem;

    root /var/www/files.ubleys.com;
    autoindex on;
    location / {
        try_files $uri $uri/ =404;
    }
}
