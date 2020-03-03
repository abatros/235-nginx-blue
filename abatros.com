server {

  server_name abatros.com;
  root /www/abatros.com;

  listen 80; # managed by Certbot

  listen 443 ssl; # managed by Certbot
  ssl_certificate /etc/letsencrypt/live/abatros.com/fullchain.pem; # managed by Certbot
  ssl_certificate_key /etc/letsencrypt/live/abatros.com/privkey.pem; # managed by Certbot
  include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
  ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
  access_log /var/log/nginx/abatros.access;
  error_log /var/log/nginx/abatros.errors;

###################################################################

  location /www-pdf {

# Simple requests
    if ($request_method ~* "(GET|POST)") {
      add_header "Access-Control-Allow-Origin"  *;
    }

    # Preflighted requests
    if ($request_method = OPTIONS ) {
      add_header "Access-Control-Allow-Origin"  *;
      add_header "Access-Control-Allow-Methods" "GET, POST, OPTIONS, HEAD";
      add_header "Access-Control-Allow-Headers" "Authorization, Origin, X-Requested-With, Content-Type, Accept";
      return 200;
    }


    autoindex on;
  





alias /home/dkz/pdf-viewer/ ;
  }


  location /pdf-viewer {

 	proxy_http_version 1.1;
   proxy_set_header Upgrade $http_upgrade;
   # proxy_set_header Connection $connection_upgrade;
   proxy_set_header Connection 'upgrade';
   proxy_set_header X-Forwarded-For $remote_addr; # preserve client IP
   proxy_set_header X-Real-IP $remote_addr;

  proxy_pass http://127.0.0.1:33103;
  }

 



location /xyz {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                try_files $uri $uri/ =404;
        }

  location ~ (/xxxxxxxxxxxx.*) {
    client_max_body_size 0; # Git pushes can be massive, just to make sure nginx doesn't suddenly cut the connection add this.
    auth_basic "Git Login"; # Whatever text will do.
    auth_basic_user_file "/home/dkz/html-git/htpasswd";
    include /etc/nginx/fastcgi_params; # Include the default fastcgi configs
    fastcgi_param SCRIPT_FILENAME /usr/lib/git-core/git-http-backend; # Tells fastcgi to pass the request to the git http backend executable
    fastcgi_param GIT_HTTP_EXPORT_ALL "";
    fastcgi_param GIT_PROJECT_ROOT /home/dkz/html-git; # /var/www/git is the location of all of your git repositories.
    fastcgi_param REMOTE_USER $remote_user;
    fastcgi_param PATH_INFO $1; # Takes the capture group from our location directive and gives git that.
    fastcgi_pass  unix:/var/run/fcgiwrap.socket; # Pass the request to fastcgi
  }





}

