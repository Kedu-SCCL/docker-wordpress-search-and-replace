# Instructions

1. Place the database dump in the 'db' directory and name as 'wordpress.sql', or whatever variable 'DB_FILENAME' is set to. Example:

```
db/wordpress.sql
```

2. Choose if you want to use the sample 'search-and-replace.sh' script for a very basic usage or follow manual instructions for more detailed steps.

## Using 'search-and-replace.sh' script

1. Execute 'search-and-replace.sh' script passing as a parameters origin and destination URLs. Example:

```
./search-and-replace.sh http://localhost:8000 http://example.com
```

2. Expected a file 'out.sql' (or whatever 'OUTPUT_FILE' variable is set to)

## Manual

1. (Optional) In case that is not the first time that you use the script, just in case bring down the environment

```
docker-compose down
```

2. Start up the environment

```
docker-compose up -d --build --force-recreate
```

3. Wait until db is ready

```
watch -n 5 "docker exec -i db mysqladmin ping -u wordpress -pwordpress"
```

Usualy it takes less than 1 minute, wait until you see below line:

...
mysqld is alive
```

Then press CTRL + C

4. Perform the replace. In this example we will replace old URL 'http://localhost:8000' by the new one 'http://example.com':

```
docker exec -ti app php /wordpress-search-and-replace/srdb.cli.php -h db -n wordpress -u wordpress -p wordpress -s "http://localhost:8000" -r "http://example.com"
```

Expected output similar to:

```
[09-Jul-2020 09:06:33 Europe/London] PHP Warning:  "continue" targeting switch is equivalent to "break". Did you mean to use "continue 2"? in /wordpress-search-and-replace/srdb.class.php on line 974
 wp_woocommerce_shipping_zone_locations: 0 rows, 0 changes found, 0 updates                     wp_woocommerce_downloadable_product_permissions: 0 rows, 0 changes found, 0 updates           
Replacing http://localhost:8000 with http://example.com 
on 46 tables with 6661 rows 

85 changes were made 
75 updates
Execution Time: 0 mins 0 secs
```

5. Test it

We would check if 'siteurl' variable has been replaced:

```
docker exec db mysql -u wordpress -pwordpress -e "use wordpress; select option_value from wp_options where option_name='siteurl';"
```

Expected output similar to:

```
http://example.com
```

6. Dump the database content with changes applied

```
docker exec -i db mysqldump wordpress -u wordpress -pwordpress > out.sql
```

A file called ```out.sql``` should be created, containing the database content with the changes applied.

7. Cleanup

```
docker-compose down
```

# Troubleshooting

## Error launching search and replace script

If you found an error similar to:

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

You should ignore table "wp_icl_locale_map". Currently the only chance is specifying as "-t" parameter the whole list of tables excluding the offending one, "wp_icl_locale_map" in this case

## db: Connection refused

If you found an error similar to:

```
[09-Jul-2020 09:24:05 Europe/London] PHP Warning:  "continue" targeting switch is equivalent to "break". Did you mean to use "continue 2"? in /wordpress-search-and-replace/srdb.class.php on line 974
mysqli_connect(): (HY000/2002): Connection refused

db: Connection refused

Execution Time: 0 mins 0 secs
```

Just wait some seconds before re-launching the command, since the database is not yet ready.
