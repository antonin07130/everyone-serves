FROM debian:jessie-backports

WORKDIR /gencerts/

COPY ./gen_temp_certs.sh gen_temp_certs.sh

 
RUN apt-get update \
  && apt-get install -y letsencrypt -t jessie-backports \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* 

RUN ls -al \
  && pwd

RUN chmod +x gen_temp_certs.sh

ENTRYPOINT ["/gencerts/gen_temp_certs.sh"]

