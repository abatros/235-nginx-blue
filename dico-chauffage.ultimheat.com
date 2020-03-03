######################
### DICO-CHAUFFAGE ###
######################

server {
   listen 80;
   root /www/dico-chauffage-2017/;
   server_name dico-chauffage.ultimheat.com;


   location /images/ {
     alias /www/dico-chauffage-2017/;
     autoindex on;
   }

   proxy_http_version 1.1;
   proxy_set_header Upgrade $http_upgrade;
   # proxy_set_header Connection $connection_upgrade;
   proxy_set_header Connection 'upgrade';
   proxy_set_header X-Forwarded-For $remote_addr; # preserve client IP
   proxy_set_header X-Real-IP $remote_addr;


   location / {
      proxy_pass http://127.0.0.1:32013;
   }
} # dico-chauffage.abatros.com

