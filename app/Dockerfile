ARG IMAGE

ARG VERSION

FROM $IMAGE:$VERSION

MAINTAINER info@kedu.coop

RUN apt-get update && apt-get install -y \
  git \
  wait-for-it

RUN git clone https://github.com/Kedu-SCCL/wordpress-search-and-replace /wordpress-search-and-replace
