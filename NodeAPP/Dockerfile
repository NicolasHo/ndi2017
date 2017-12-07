FROM keymetrics/pm2:latest

LABEL maintainer="BriGIT"

ADD app .

ADD app/pm2.json .

ADD app/package.json .

ENTRYPOINT npm i && pm2-docker start pm2.json

EXPOSE  8080
