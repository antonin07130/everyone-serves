self contained wordpress site
=============================

this repository is a set of docker container working together to serve a wordpress website.

 * Services architecture :

> |-------|  |------------|  |---------|
> |  db   |  | wordpress  |  |  server |-exposes port 8080:80
> |       |  |4.7.2-php7.1|  |         |
> |mariadb|  |-fpm-alpine |  |  nginx  |
> |-------|  |------------|  |---------|
>   : |        : |  |       :    | :
>   : |-lan_wpdb-|  |-lan_server-| :
>   :          :            :      :
>  vol_wpdb   ./www/html   ./www/html
>                                  :
>                                 nginx/conf.d/* 
>                                 nginx/nginx.conf

 * website content

Are in ./www and are accessible to server as read only (to server static content), and to php.

 * website configuration & posts

Are stored in vol_wpdb, only accessible to db container.

 * server configuration

Sites configurations are in nginx/conf.d/.
Main configuration file is nginx.conf.


