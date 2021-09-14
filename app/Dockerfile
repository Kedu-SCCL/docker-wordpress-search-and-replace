ARG IMAGE

ARG VERSION

FROM $IMAGE:$VERSION

# IMPORTANT: remeber to declare ARG values AFTER FROM sentence....

ARG MEMORY_LIMIT=128m

MAINTAINER info@kedu.coop

RUN apt-get update && apt-get install -y \
  git 

RUN echo "memory_limit=$MEMORY_LIMIT" > /usr/local/etc/php/php.ini

RUN git clone https://github.com/Kedu-SCCL/wordpress-search-and-replace /wordpress-search-and-replace
