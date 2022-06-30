# use this empty Dockerfile to build your assignment

# NOTE: The instructions are now in the README.md file in this directory.

FROM node:6-alpine

EXPOSE 3000

RUN apk add --no-caache tini

WORKDIR /usr/src/app
COPY package.json package.json

RUN npm install \
	&& npm cache clean --force

COPY app.js app.js
COPY bin bin
COPY public public
COPY routes routes
COPY views views

STOPSIGNAL SIGTERM

CMD ["/sbin/tini", "--", "node", "./bin/www"]

