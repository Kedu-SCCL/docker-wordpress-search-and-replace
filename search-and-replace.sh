#!/bin/bash

set -e

function num_server_started()
{
    echo `docker logs $DB_NAME 2>&1 | grep -c "$SERVER_STARTED_LOG"`
}

function add_use_database()
{
    if grep -iq "^use .*;" db/$DB_FILENAME
    then
        sed -i "s/^[uU][sS][eE].*;/USE \`$DB_MYSQL_DATABASE\`;/g" db/$DB_FILENAME
    else
        sed -i "1s/^/USE \`$DB_MYSQL_DATABASE\`;\n/" db/$DB_FILENAME
    fi
}

source .env

if [ "$#" -ne 2 ]; then
    printf "2 parameters expected\nExample:\n./search-and-replace.sh http://old http://new\n"
    exit 1
fi

docker-compose down

add_use_database

docker-compose up -d --build --force-recreate

while [ `num_server_started` -lt 2 ]; do
    echo 'Waiting on database server is started up. Sleeping '$SLEEP's...'
    sleep $SLEEP
done

docker exec -i $APP_NAME php /wordpress-search-and-replace/srdb.cli.php -h $DB_NAME -n $DB_MYSQL_DATABASE -u $DB_MYSQL_USER -p $DB_MYSQL_PASSWORD -s $1 -r $2

rm -fr $OUTPUT_FILE

docker exec -i $DB_NAME mysqldump --extended-insert=FALSE $DB_MYSQL_DATABASE -u $DB_MYSQL_USER -p$DB_MYSQL_PASSWORD > $OUTPUT_FILE

docker-compose down
