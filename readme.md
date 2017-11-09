# Deprecated

This repo was to play with docker and docker compose, if you need to serve several websites with a similar setup, head up to https://rancher.com or some similar soft which are really maintained and have some safety warranties.

self contained wordpress site
=============================

this repository is a set of docker container working together to serve 2 wordpress websites and a gitlab server.

 * Services architecture :
```

>                        |---------|                       |-------------| 
>    ./nginx/conf.d/* +++|  server |-exposes port 8080:80  | letsencrypt |
>    ./nginx/nginx.conf +|         |                       |             |
>                        |  nginx  |                       | letsencrypt |
>                        |---------|                       |-------------|
>                          |  +  +                             |      +   
>                          |  +  +++++++++++++++++++++++++++++++++++  +   
>                   ----lan_server-----------------------------|   +  +
>                   |         +      |               |             +  +
> |-------|  |------------|   + |------------|    |---------|      vol_letsencrypt_certs
> |  db   |  | wordpress  |   + | wordpress  |    | gitlab  |      vol_letsencrypt_www
> |       |  |4.7.2-php7.1|   + |4.7.2-php7.1|    |         |
> |mariadb|  |-fpm-alpine |   + |-fpm-alpine |    |         |
> |-------|  |------------|   + |------------|    |---------|
>   +  |             | +      +   | +
>   +  |--lan_wpdb---|------------| + 
>   +                  +      +     +
>  vol_wpdb   ./www/html/ento +    ./www/html/kawale
>                             +
>                           ./www/html/    
>                                  
>                                 
```

Wordpress Blogs
===============

 * website content

Are in ./www and are accessible to reverse proxy server as read only (to serve static content).
Each blog has his own directory (ento and kawale)

 * website configuration & posts

Are stored in vol_wpdb, only accessible to db container.

 * server

Blog containers run a php-fpm service to serve dynamic php contents.
The reverse proxy redirects php requests to these servers.
The reverse proxy deals directly with static content, serving it from ./www/html


Gitlab
======

 * Gitlab contents

Are in vol_gitlab_contents.

 * Gilab configuration

Proxy configuration is in docker-compose (arguments to the container run command).
Other configuration can be set in ./gitlab/gitlab.rb


Reverse Proxy (server)
======================

 * server configuration

Sites configurations and letsencrypt configurations are in nginx/conf.d/.
Main configuration file is nginx.conf.


 * certificates

The server reads certificates from vol_letsencrypt_certs.

The letsencrypt container is responsible for generating certificates :
1. At first, it generates temporary self signed certificates, for nginx to be able to start.
2. It waits for 30 seconds and remove these temporary certificates.
3. Finally, it starts letsencrypt bot and get these certificates


The server redirects requests to .well-known/acme-challenge/ to letsencrypt image, for the certificate generator bot to intercept them.


