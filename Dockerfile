FROM alpine:latest as build

RUN apk add --no-cache \
  hugo \
  exiftool \
  jpegoptim \
  optipng \
  imagemagick

WORKDIR /src
COPY . .

RUN hugo --gc --minify && ./bin/compression.sh

FROM nginx:alpine
COPY --from=build /src/public/ /usr/share/nginx/html

#LABEL org.opencontainers.image.source="https://github.com/thomasnotfound/how.wtf"
#LABEL org.opencontainers.image.description="Houses the how.wtf "
