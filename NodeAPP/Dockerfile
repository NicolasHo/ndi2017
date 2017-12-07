FROM ubuntu

LABEL maintainer="Oliger Timothee"

ADD ./app /app

RUN apt-get update && apt-get install -y python apt-utils dialog openssh-client curl git &&\
  curl -sL https://deb.nodesource.com/setup_8.x | bash - &&\
  apt-get install -y nodejs build-essential

ADD NodeAPP/app .

ADD NodeAPP/app/pm2.json .

ADD NodeAPP/app/package.json .

ENTRYPOINT cd /app && npm i && pm2-docker start pm2.json

EXPOSE  8080
