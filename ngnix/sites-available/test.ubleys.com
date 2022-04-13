# Virtual Host configuration for test.ubleys.com

server {
    listen 80;
    listen [::]:80;

    location /.well-known/acme-challenge/ {
          root /var/www/test.ubleys.com;
    }

    server_name test.ubleys.com www.test.ubleys.com;
    server_tokens off;

    location / {
           return 301 https://test.ubleys.com$request_uri;
    }
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;

    server_name test.ubleys.com;

    ssl_certificate /etc/nginx/ssl/live/test.ubleys.com/fullchain.pem;
    ssl_certificate_key /etc/nginx/ssl/live/test.ubleys.com/privkey.pem;
    
    root /var/www/test.ubleys.com;

    location / {
        try_files $uri $uri/ =404;
    }
}
