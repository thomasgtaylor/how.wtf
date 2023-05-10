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

FROM busybox:uclibc

LABEL org.opencontainers.image.source="https://github.com/thomasnotfound/how.wtf"
LABEL org.opencontainers.image.description="Official how.wtf image"

COPY --from=build /src/public/ /
CMD ["busybox", "httpd", "-f", "-v", "-p", "1313"]
