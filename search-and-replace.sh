#!/bin/bash

set -e

function num_server_started()
{
    echo `docker logs $GENERATED_DB_NAME 2>&1 | grep -c "$SERVER_STARTED_LOG"`
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

# Let's get the timestamp in nanoseconds to allow concurrent executions, for instance when executed from Continous Integration (CI)
TIMESTAMP=`date +%s%N`

# DB container name relies on docker-compose.yml file, currently 'db'
GENERATED_DB_NAME=$TIMESTAMP"_"$DB_NAME"_1"

# App container name relies on docker-compose.yml file, currently 'app'
GENERATED_APP_NAME=$TIMESTAMP"_"$APP_NAME"_1"

docker-compose -p $TIMESTAMP down

add_use_database

docker-compose -p $TIMESTAMP up -d --build --force-recreate

while [ `num_server_started` -lt 2 ]; do
    echo 'Waiting on database server is started up. Sleeping '$SLEEP's...'
    sleep $SLEEP
done

docker exec -i $GENERATED_APP_NAME php /wordpress-search-and-replace/srdb.cli.php -h $GENERATED_DB_NAME -n $DB_MYSQL_DATABASE -u $DB_MYSQL_USER -p $DB_MYSQL_PASSWORD -s $1 -r $2

rm -fr $OUTPUT_FILE

docker exec -i $GENERATED_DB_NAME mysqldump --extended-insert=FALSE $DB_MYSQL_DATABASE -u $DB_MYSQL_USER -p$DB_MYSQL_PASSWORD > $OUTPUT_FILE

docker-compose -p $TIMESTAMP down
