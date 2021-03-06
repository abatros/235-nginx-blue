
#limit_zone pdf_zone $binary_remote_addr 10m;
limit_req_zone $binary_remote_addr zone=pdf_zone:10m rate=1r/s;



server {
  listen 80;
  server_name downloads.ultimheat.com;
  root /www/ultimheat-downloads;
  autoindex on;

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/downloads.ultimheat.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/downloads.ultimheat.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}


#server {
#  listen 80;
#  server_name ultimheat.abatros.com;
#  root /home/dkz/tmp/git-u7;
#  }



#server {
#  listen 80;
#  listen [::]:80;
#  server_name ultimheat.com www.ultimheat.com;
#  return 301 https://$server_name$request_uri;
#}



server {
  server_name ultimheat.com www.ultimheat.com;
	

	root /home/dkz/tmp/git-u7;


	access_log /var/log/nginx/dkz-ultimheat.access;
        error_log /var/log/nginx/dkz-ultimheat.errors;



	location /Museum/ {
		rewrite ^/Museum/(.*)\.pdf$ http://ultimheat.com/museum1(EN).html permanent;
	}

#   rewrite ^/Museum/section1/(.*)\.pdf$ /museum1(EN).html;
#	rewrite ~/Museum/section1/*\.pdf$ /new-museum.html last;

#	location ~ Museum*\.pdf$ {
#   	rewrite ^(.*) http://ultimheat.com/new-museum.html;
#		return 301 http://ultimheat.com/new-museum.html;
#	}
	

#
# this is important bc Google knows those files.
#

	#rewrite /blueink http://ultimheat.co.th permanent;


	location ~ ^/museum/([0-9]+)(.*)\.html$ {
      add_header X-dkz-tail "$2.html";
 #     root /home/dkz/ultimheat.com/;
      charset utf8;
   	#proxy_pass http://127.0.0.1:32020/museum-app/xp/article/$1;
		proxy_pass http://127.0.0.1:32022/page/$1;

      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection 'upgrade';
      proxy_set_header X-Forwarded-For $remote_addr; # preserve client IP
      proxy_set_header X-Real-IP $remote_addr;
		break;
   }



	location /editora {
      add_header X-uri-dkz "Hello Article-$1";
      #proxy_pass http://127.0.0.1:32020/museum-app/xp/article/$1;
      proxy_pass http://127.0.0.1:32040/editora;
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection 'upgrade';
      proxy_set_header X-Forwarded-For $remote_addr; # preserve client IP
      proxy_set_header X-Real-IP $remote_addr;


}


	location  ^/museum/ {
      add_header X-uri-dkz "Hello Article-$1";
      #proxy_pass http://127.0.0.1:32020/museum-app/xp/article/$1;
      proxy_pass http://127.0.0.1:32020/museum-app/xp/;
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection 'upgrade';
      proxy_set_header X-Forwarded-For $remote_addr; # preserve client IP
      proxy_set_header X-Real-IP $remote_addr;
   }


	location ~ ^/museum/ {
      add_header X-uri-dkz "Hello Index";
      #alias /home/dkz/ultimheat.com/museum/;
      root /home/dkz/ultimheat.com/;
      charset utf8;
      break;
   }

	  location /museum-app/ {
      #include  /etc/nginx/mime.types;
      proxy_pass http://127.0.0.1:32020/museum-app/;
      #rewrite /museum-app(.*) /museum-v9/$1  break;
      #proxy_redirect http://$host/ http://localhost:32020/museum-v9/
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      # proxy_set_header Connection $connection_upgrade;
      proxy_set_header Connection 'upgrade';
      proxy_set_header X-Forwarded-For $remote_addr; # preserve client IP
      proxy_set_header X-Real-IP $remote_addr;
      #rewrite /museum-app(.*) /museum-v9$1  break;
   }


   proxy_http_version 1.1;
   proxy_set_header Upgrade $http_upgrade;
   # proxy_set_header Connection $connection_upgrade;
   proxy_set_header Connection 'upgrade';
   proxy_set_header X-Forwarded-For $remote_addr; # preserve client IP
   proxy_set_header X-Real-IP $remote_addr;

	proxy_set_header Host $host;
 	#proxy_cache_bypass $http_upgrade;

   location /mumu/ {
      proxy_pass http://127.0.0.1:32020;
   }

	location /dico-chauffage {
      rewrite ^/dico-chauffage/(.*)$ http://dico-chauffage.ultimheat.com/$1;
		#return 301 http://dico-chauffage2.ultimheat.com;
   }


	#rewrite ^/dkz http://dkz.ultimheat.com; 

	location /dkz/ {
		#rewrite ^ http://dkz.ultimheat.com permanent;
		return 301 http://dkz.ultimheat.com;
	}






    listen [::]:443 ssl; # managed by Certbot
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/ultimheat.com-0001/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/ultimheat.com-0001/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot



}  # ultimheat.com







server {
    if ($host = www.ultimheat.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    if ($host = ultimheat.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


  listen 80;
  listen [::]:80;
  server_name ultimheat.com www.ultimheat.com omg.ultimheat.com;
    return 404; # managed by Certbot




}
