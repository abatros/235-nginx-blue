server {
   listen 80;
   root /home/dkz/tmp;
   server_name git-app.ultimheat.com;


   proxy_http_version 1.1;
   proxy_set_header Upgrade $http_upgrade;
   # proxy_set_header Connection $connection_upgrade;
   proxy_set_header Connection 'upgrade';
   proxy_set_header X-Forwarded-For $remote_addr; # preserve client IP
   proxy_set_header X-Real-IP $remote_addr;


   location / {
      proxy_pass http://127.0.0.1:32036;
   }


} # git.ultimheat.com

server {
   listen 80;
   root /home/dkz/tmp;
   server_name git.ultimheat.com;


   proxy_http_version 1.1;
   proxy_set_header Upgrade $http_upgrade;
   # proxy_set_header Connection $connection_upgrade;
   proxy_set_header Connection 'upgrade';
   proxy_set_header X-Forwarded-For $remote_addr; # preserve client IP
   proxy_set_header X-Real-IP $remote_addr;


   location / {
      proxy_pass http://127.0.0.1:7005;
   }


} # git.ultimheat.com


