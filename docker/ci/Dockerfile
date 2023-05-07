FROM ubuntu:23.04

LABEL org.opencontainers.image.source="https://github.com/thomasnotfound/how.wtf"
LABEL org.opencontainers.image.description="CI build image for publishing how.wtf"

RUN apt-get update && apt-get install -y \
  git \
  libimage-exiftool-perl \
  jpegoptim \
  optipng \
  graphicsmagick-imagemagick-compat
