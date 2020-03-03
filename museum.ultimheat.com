server {
  server_name museum.ultimheat.com;
  root /www/museum-assets;



  location / {
    proxy_pass http://127.0.0.1:32022;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    # proxy_set_header Connection $connection_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header X-Forwarded-For $remote_addr; # preserve client IP
    proxy_set_header X-Real-IP $remote_addr;
  }



  location /deep-shit/ {
    proxy_pass http://127.0.0.1:32131;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    # proxy_set_header Connection $connection_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header X-Forwarded-For $remote_addr; # preserve client IP
    proxy_set_header X-Real-IP $remote_addr;
  }


#    listen 443 ssl; # managed by Certbot
#    ssl_certificate /etc/letsencrypt/live/museum.inhelium.com/fullchain.pem; # managed by Certbot
#    ssl_certificate_key /etc/letsencrypt/live/museum.inhelium.com/privkey.pem; # managed by Certbot
#    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
#    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot


#    listen 443 ssl; # managed by Certbot
#    ssl_certificate /etc/letsencrypt/live/abatros.com/fullchain.pem; # managed by Certbot
#    ssl_certificate_key /etc/letsencrypt/live/abatros.com/privkey.pem; # managed by Certbot
#    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
#    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot


    listen 80; # managed by Certbot

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/museum.ultimheat.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/museum.ultimheat.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}

#server {
#    if ($host = museum.ultimheat.com) {
#        return 301 https://$host$request_uri;
#    } # managed by Certbot


#  listen 80;
#  server_name museum.ultimheat.com;
#    return 404; # managed by Certbot


#}


