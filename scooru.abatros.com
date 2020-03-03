server {
   listen 80;
   root /home/dkz/tmp;
   server_name scooru.abatros.com webapp.scooru.com scooru.com www.scooru.com;


   location /static/ {
      alias /www/scooru/;
      autoindex on;
   }

   proxy_http_version 1.1;
   proxy_set_header Upgrade $http_upgrade;
   # proxy_set_header Connection $connection_upgrade;
   proxy_set_header Connection 'upgrade';
   proxy_set_header X-Forwarded-For $remote_addr; # preserve client IP
   proxy_set_header X-Real-IP $remote_addr;


   location / {
      proxy_pass http://127.0.0.1:33101;
   }

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/scooru.abatros.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/scooru.abatros.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

} # dico-chauffage.ultimheat.com

