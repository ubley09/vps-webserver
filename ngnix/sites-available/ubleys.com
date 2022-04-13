# Virtual Host configuration for ubleys.com

server {
    listen 80;
    listen [::]:80;

    location /.well-known/acme-challenge/ {
          root /var/www/ubleys.com;
    }

    server_name ubleys.com www.ubleys.com;
    server_tokens off;

    location / {
           return 301 https://ubleys.com$request_uri;
    }
}


server {
    listen 443 default_server ssl http2;
    listen [::]:443 ssl http2;

    server_name ubleys.com;

    ssl_certificate /etc/nginx/ssl/live/ubleys.com/fullchain.pem;
    ssl_certificate_key /etc/nginx/ssl/live/ubleys.com/privkey.pem;
    
    root /var/www/ubleys.com;

    location / {
        try_files $uri $uri/ =404;
    }
}
