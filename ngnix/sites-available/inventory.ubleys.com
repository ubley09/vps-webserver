# Virtual Host configuration for inventory.ubleys.com

server {
    listen 80;
    listen [::]:80;

    location /.well-known/acme-challenge/ {
          root /var/www/inventory.ubleys.com;
    }

    server_name inventory.ubleys.com www.inventory.ubleys.com;
    server_tokens off;

    location / {
           return 301 https://inventory.ubleys.com$request_uri;
    }
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;

    server_name inventory.ubleys.com;

    ssl_certificate /etc/nginx/ssl/live/inventory.ubleys.com/fullchain.pem;
    ssl_certificate_key /etc/nginx/ssl/live/inventory.ubleys.com/privkey.pem;

    root /var/www/inventory.ubleys.com;

    location / {
        try_files $uri $uri/ =404;
    }

    access_log /var/ngnix/log/inventory.ubleys.com;
}
