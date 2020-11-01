FROM node:10-alpine

ENV VS_ENV prod

EXPOSE 8080
EXPOSE 3000

WORKDIR /var/www

COPY shims.d.ts ./
COPY tsconfig.json ./
COPY tsconfig-build.json ./
COPY package.json ./
COPY yarn.lock ./
COPY config ./config
COPY core ./core
COPY ecosystem.json ./
COPY .eslintignore ./
COPY .eslintrc.js ./
COPY lerna.json ./
COPY package.json ./
COPY src ./src

RUN apk add --virtual .build-deps ca-certificates wget python make g++ \
  && apk add git \
  && yarn install \
  && yarn build 

CMD [ "./node_modules/.bin/pm2-runtime", "start", "ecosystem.json", "$PM2_ARGS"]

#RUN apk add --no-cache --virtual .build-deps ca-certificates wget python make g++ \
#  && apk add --no-cache git \
#  && yarn install --no-cache \
#  && apk del .build-deps \
#  && yarn build

#COPY vue-storefront.sh /usr/local/bin/

#CMD ["vue-storefront.sh"]
