#!/bin/bash

# Generates 3 certificates pairs in 
# /etc/letsencrypt/live/www.kawale.org
# /etc/letsencrypt/live/www.ento.kawale.org
# /etc/letsencrypt/live/gitlab.kawale.org


mkdir -p /etc/letsencrypt/live/www.kawale.org

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
 -keyout /etc/letsencrypt/live/www.kawale.org/privkey.pem \
 -out /etc/letsencrypt/live/www.kawale.org/fullchain.pem \
 -subj /CN=www.kawale.org \


mkdir -p /etc/letsencrypt/live/www.ento.kawale.org

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
 -keyout /etc/letsencrypt/live/www.ento.kawale.org/privkey.pem \
 -out /etc/letsencrypt/live/www.ento.kawale.org/fullchain.pem \
 -subj /CN=www.ento.kawale.org \


mkdir -p /etc/letsencrypt/live/gitlab.kawale.org

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
 -keyout /etc/letsencrypt/live/gitlab.kawale.org/privkey.pem \
 -out /etc/letsencrypt/live/gitlab.kawale.org/fullchain.pem \
 -subj /CN=gitlab.kawale.org


# dirty sleep to let nginx start with fake certificates
sleep 30

# remove fake certificates
rm -rf /etc/letsencrypt/live/gitlab.kawale.org
rm -rf /etc/letsencrypt/live/www.ento.kawale.org
rm -rf /etc/letsencrypt/live/www.kawale.org

# start certbot certification process
certbot certonly --noninteractive --agree-tos --verbose --config /gencerts/cli.ini



