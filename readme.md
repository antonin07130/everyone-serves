self contained wordpress site
=============================

this repository is a set of docker container working together to serve 2 wordpress websites and a gitlab server.

 * Services architecture :
```

>                        |---------|                       |-------------| |-------------|
>    ./nginx/conf.d/* +++|  server |-exposes port 8080:80  | letsencrypt | | temt_certs  |
>    ./nginx/nginx.conf +|         |                       |             | |             |
>                        |  nginx  |                       | letsencrypt | | dockerfile/ |
>                        |---------|                       |-------------| |letsencrypt/ |
>                          |  +  +                             |      +    |Dockerfile   |
>                          |  +  +++++++++++++++++++++++++++++++++++  +    |-------------|
>                   ----lan_server-----------------------------|   +  +        +
>                   |         +      |               |             +  +        +
> |-------|  |------------|   + |------------|    |---------|      vol_letsencrypt_certs
> |  db   |  | wordpress  |   + | wordpress  |    | gitlab  |      vol_letsencrypt_www
> |       |  |4.7.2-php7.1|   + |4.7.2-php7.1|    |         |
> |mariadb|  |-fpm-alpine |   + |-fpm-alpine |    |         |
> |-------|  |------------|   + |------------|    |---------|
>   + |        + |            +   | +
>   + |-lan_wpdb-|----------------| + 
>   +          +              +     +
>  vol_wpdb   ./www/html/ento +    ./www/html/kawale
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
The reverse proxy redirects appropriate requests to these servers.


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

2 containers are used to get certificates for reverse proxy :
 * temp_certs is a home made image that generates self signed certificates and stores them in vol_letsencrypt_certs.(without these, nginx reverse proxy refuses to start)
 * letsencrypt is the official letsencrypt image that gets signed certificates and stores them in vol_letsencrypt_certs replacing self signed certiicates. This replacement step does not work correctly yet.

The server serves specifically the .well-known/acme-challenge/ from vol_letsencrypt_www (populated by the letsencrypt container).

