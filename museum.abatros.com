server {
  listen 80;
  server_name museum.abatros.com;
  root /home/dkz/Museum;

  location /test {
    alias /home/dkz/Museum/test;
  }

  location / {
    proxy_pass http://127.0.0.1:32034;
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

}
