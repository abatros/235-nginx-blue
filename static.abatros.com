server {
  listen 80;
  listen [::]:80;

  root /www;
  server_name static.abatros.com;
  autoindex on;

  location /* {

if ($request_method = 'OPTIONS') {
                add_header "Access-Control-Allow-Origin" $http_origin;
                add_header "Vary" "Origin";
                add_header 'Access-Control-Allow-Credentials' 'true';
                add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
	        #add_header 'Access-Control-Allow-Headers';        
add_header 'Access-Control-Allow-Headers' 'DNT,Range,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Acopenept-Ranges,Content-Encoding,Content-Range,Content-Length';
                # Tell client that this pre-flight info is valid for 20 days
                add_header 'Access-Control-Max-Age' 1728000;
                add_header 'Content-Type' 'text/plain charset=UTF-8';
                add_header 'Content-Length' 0;
                return 204;
             }

             if ($request_method = 'POST') {
                add_header 'Access-Control-Allow-Origin' '*';
                add_header 'Access-Control-Allow-Credentials' 'true';
                add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
                add_header 'Access-Control-Allow-Headers' 'DNT,Range,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Acopenept-Ranges,Content-Encoding,Content-Range,Content-Length';
                #add_header 'Access-Control-Expose-Headers' 'Accept-Ranges,Content-Encoding,Content-Length,Content-Range,Cache-Control,Content-Language,Content-Type,Expires,Last-Modified,Pragma,Date';
             }

             if ($request_method = 'GET') {
                add_header "Access-Control-Allow-Origin" $http_origin;
                add_header "Vary" "Origin";
                add_header 'Access-Control-Allow-Credentials' 'true';
                add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
                #add_header 'Access-Control-Allow-Headers' 'DNT,Range,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Acopenept-Ranges,Content-Encoding, Content-Range, Content-Length';
                add_header 'Access-Control-Expose-Headers' 'Accept-Ranges,Content-Encoding,Content-Length,Content-Range,Cache-Control,Content-Language,Content-Type,Expires,Last-Modified,Pragma,Date';
             }
#    autoindex on;
   }


  location / {
    autoindex off;
  }

}
