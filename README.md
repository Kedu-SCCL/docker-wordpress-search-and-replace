# Initial setup (just one time)

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

# Start the environment

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

# Search and replace (domain changes)

Procedure needed by Wordpress when hostname part changes. See [this](https://wordpress.org/support/article/changing-the-site-url/)


1. Launch below command, adjusting database settings:

```
docker exec -ti app php /search-replace-wp-kedu/srdb.cli.php -h db -n handytec -u handytec -p handytec -s 'http://handytec.es/v1' -r 'localhost' 
```

Expected output similar to:

```
wp_woocommerce_shipping_zone_locations: 0 rows, 0 changes found, 0 updates                     wp_woocommerce_downloadable_product_permissions: 0 rows, 0 changes found, 0 updates           
Replacing http://handytec.es/v1 with localhost 
on 89 tables with 49861 rows 

0 changes were made 
0 updates

results: The table "wp_icl_locale_map" has no primary key. 
Changes will have to be made manually.

Execution Time: 0 mins 1 secs
```

In this case the procedure failed, we should ignore table "wp_icl_locale_map"

2. Test it

2.1. Connect to the database container

```
docker exec -ti db bash
```

2.2. Connect to database engine

```
mysql -u root -p
```

2.3. Connect to the right database

```
use handytec;
```

2.4. Check value of "siteurl" variable

```
select * from wp_options where option_name like 'siteurl';
```

Expected output similar to:

```
TODO: provide output
```

If the output does not matches the "-r" parameter of step 1 the replacement went wrong and we need to launch it again, maybe excluding tables with primary keys

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




