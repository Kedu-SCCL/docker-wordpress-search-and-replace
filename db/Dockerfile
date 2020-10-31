ARG IMAGE

ARG VERSION

FROM $IMAGE:$VERSION

ARG DB_FILENAME

MAINTAINER info@kedu.coop

#  The .sql file (if any) will be copied here, because if the 'docker-compose up' command is executed from within a docker container (for instance jenkins node) the volume will not work, will be empty
COPY $DB_FILENAME /docker-entrypoint-initdb.d
