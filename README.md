# Usage

## Initial setup (just one time)

1. Get a wordpress database backup and place it at "db.sql"

2. Get a wordpress filesystem backup and place it at "html"

3. Adjust "wp-config.php" settings to match database credentials of ".env" file

## Start the environment

1. Bring down the environment

```
docker-compose down
```

2. Start up the environment

```
docker-compose up -d
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
