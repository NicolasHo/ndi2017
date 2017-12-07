FROM keymetrics/pm2:latest

LABEL maintainer="BriGIT"

RUN apt-get update && apt-get upgrade -y && apt-get install -y python

ADD NodeAPP/app .

ADD NodeAPP/app/pm2.json .

ADD NodeAPP/app/package.json .

ENTRYPOINT cd /app && npm i && pm2-docker start pm2.json

EXPOSE  8080
