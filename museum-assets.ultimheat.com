server {
   listen 80;
   server_name museum-assets.ultimheat.com;
   root /www/museum-assets/;
   autoindex on;
   
   #charset_types text/plain utf8;
   charset utf-8;
   #charset_types text/plain;
   #charset $charset;
   #charset_types *;

}

