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

Until you see some lines similar to:

```
...
MySQL init process done. Ready for start up.
...
2019-07-11  9:07:35 0 [Note] mysqld: ready for connections.
```

4. Test it

http://localhost

TODO: more information coming soon

# Search and replace (domain changes)

Procedure needed by Wordpress when hostname part changes. See [this](https://wordpress.org/support/article/changing-the-site-url/)


1. Launch below command, adjusting database settings:

```
TABLES=wp5h_commentmeta,wp5h_comments,wp5h_links,wp5h_options,wp5h_postmeta,wp5h_posts,wp5h_term_relationships,wp5h_term_taxonomy,wp5h_termmeta,wp5h_terms,wp5h_usermeta,wp5h_users,wp_blc_filters,wp_blc_instances,wp_blc_links,wp_blc_synch,wp_commentmeta,wp_comments,wp_icl_cms_nav_cache,wp_icl_content_status,wp_icl_core_status,wp_icl_flags,wp_icl_languages,wp_icl_languages_translations,wp_icl_message_status,wp_icl_mo_files_domains,wp_icl_node,wp_icl_reminders,wp_icl_string_packages,wp_icl_string_pages,wp_icl_string_positions,wp_icl_string_status,wp_icl_string_translations,wp_icl_string_urls,wp_icl_strings,wp_icl_translate,wp_icl_translate_job,wp_icl_translation_batches,wp_icl_translation_status,wp_icl_translations,wp_layerslider,wp_layerslider_revisions,wp_links,wp_options,wp_postmeta,wp_posts,wp_revslider_css,wp_revslider_layer_animations,wp_revslider_navigations,wp_revslider_sliders,wp_revslider_slides,wp_revslider_static_slides,wp_rg_form,wp_rg_form_meta,wp_rg_form_view,wp_rg_incomplete_submissions,wp_rg_lead,wp_rg_lead_detail,wp_rg_lead_detail_long,wp_rg_lead_meta,wp_rg_lead_notes,wp_smush_dir_images,wp_term_relationships,wp_term_taxonomy,wp_termmeta,wp_terms,wp_usermeta,wp_users,wp_w3tc_cdn_queue,wp_wc_download_log,wp_wc_webhooks,wp_woocommerce_api_keys,wp_woocommerce_attribute_taxonomies,wp_woocommerce_downloadable_product_permissions,wp_woocommerce_log,wp_woocommerce_order_itemmeta,wp_woocommerce_order_items,wp_woocommerce_payment_tokenmeta,wp_woocommerce_payment_tokens,wp_woocommerce_sessions,wp_woocommerce_shipping_zone_locations,wp_woocommerce_shipping_zone_methods,wp_woocommerce_shipping_zones,wp_woocommerce_tax_rate_locations,wp_woocommerce_tax_rates,wp_woocommerce_termmeta,wp_yoast_seo_links,wp_yoast_seo_meta &&\
docker exec -ti app php /search-replace-wp-kedu/srdb.cli.php -h db -n handytec -u handytec -p handytec -s "http://www.handytec.es/v1" -r "http://localhost" -t $TABLES
```

Expected output similar to:

```
 wp_woocommerce_downloadable_product_permissions: 0 rows, 0 changes found, 0 updates            wp_woocommerce_shipping_zone_locations: 0 rows, 0 changes found, 0 updates                    
Replacing http://www.handytec.es/v1 with http://localhost 
on 88 tables with 49861 rows 

1072 changes were made 
998 updates
Execution Time: 0 mins 6 secs
```

2. Test it

2.1. Launch below command

```
docker exec -ti db mysql -u handytec -p -e "use handytec; select * from wp_options where option_name like 'siteurl';"
```

Expected output similar to:

```
+-----------+-------------+------------------+----------+
| option_id | option_name | option_value     | autoload |
+-----------+-------------+------------------+----------+
|         1 | siteurl     | http://localhost | yes      |
+-----------+-------------+------------------+----------+
```

If the output does not matches the "-r" parameter of step 1 the replacement went wrong and we need to launch it again, maybe excluding tables with primary keys.

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


