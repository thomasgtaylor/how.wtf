FROM alpine:latest as build

RUN apk add --no-cache \
  hugo \
  exiftool \
  jpegoptim \
  oxipng \
  imagemagick

WORKDIR /src
COPY . .

RUN hugo --gc --minify

FROM busybox:uclibc

LABEL org.opencontainers.image.source="https://github.com/thomasnotfound/how.wtf"
LABEL org.opencontainers.image.description="Official how.wtf image"

COPY --from=build /src/public/ /var/www/html
CMD ["busybox", "httpd", "-f", "-v", "-p", "1313", "-h", "/var/www/html"]
