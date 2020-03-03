server {
   listen 80;
   server_name museum-assets-v3.ultimheat.com;
   root /www/museum-assets-v3/;
   autoindex on;

   #charset_types text/plain utf8;
   charset utf-8;
   #charset_types text/plain;
   #charset $charset;
   #charset_types *;

}




server {
  server_name museum2.ultimheat.com;
  root /www/museum-assets-v3;



  location / {
    proxy_pass http://127.0.0.1:32042;
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

}


server {
  listen 80;
  listen [::]:80;
  server_name catalogs.ultimheat.com;
  return 301 https://$server_name$request_uri;
}



server {
  root /www/jpc-catalogs;


  location / {
    proxy_pass http://127.0.0.1:32028;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    # proxy_set_header Connection $connection_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header X-Forwarded-For $remote_addr; # preserve client IP
    proxy_set_header X-Real-IP $remote_addr;
  }

}
