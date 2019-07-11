# Usage

## Initial setup (just one time)

1. (Optional) Edit ".env" file to seup variables

```
vim .env
```

For instance database credentials:

```
DB_MYSQL_DATABASE=handytec
DB_MYSQL_USER=handytec
DB_MYSQL_PASSWORD=handytec
DB_MYSQL_ROOT_PASSWORD=handytec
```

2. Get a wordpress database backup and place it at "db.sql" (or the name of "DB_BACKUP_FILENAME" variable in ".env" file)

3. Get a wordpress filesystem backup and place it at "html" (or the name of "APP_HTML" variable in ".env" file)

4. Adjust "wp-config.php" settings to match database credentials of ".env" file

## Start the environment

1. Bring down the environment

```
docker-compose down
```

2. Start up the environment

```
docker-compose up --build -d
```

3. Wait until db is ready. It cant take 1m to 4m to startup

3.1. Tail the logs

```
docker logs -f db
```

Until you see a line similar to:

```
2019-07-11  6:12:44 0 [Note] mysqld: ready for connections.
```

4. Test it

http://localhost

TODO: more information coming soon

# Stop

```
cd /path/to/docker-handytec
docker-compose stop
```
# Clean up

```
cd /path/to/docker-handytec
docker-compose down
```




