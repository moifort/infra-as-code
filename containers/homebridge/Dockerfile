FROM node:7.3.0
MAINTAINER ViViDboarder <vividboarder@gmail.com>


RUN npm install -g --unsafe-perm homebridge 

EXPOSE 51826

USER root

RUN mkdir -p /root/.homebridge
VOLUME /root/.homebridge
WORKDIR /root/.homebridge

ADD start.sh /root/.homebridge/start.sh

CMD /root/.homebridge/start.sh
