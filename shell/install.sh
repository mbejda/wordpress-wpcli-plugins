#!/bin/bash
/etc/init.d/ssh start;
/etc/init.d/proftpd start;
/etc/init.d/mysql start;\
	sleep 3;\
	echo 'CREATE DATABASE wordpress; GRANT ALL PRIVILEGES ON wordpress.* TO "wordpress"@"127.0.0.1" IDENTIFIED BY "wordpress"; FLUSH PRIVILEGES;' | mysql -h127.0.0.1 -uroot

cd /var/www/wordpress
#wp core download --allow-root
wp core config --path=/var/www/wordpress --dbhost="127.0.0.1" --dbname="wordpress" --dbuser="wordpress" --dbpass="wordpress" --allow-root --extra-php <<PHP
define( 'WP_DEBUG', true );
define( 'WP_DEBUG_LOG', true );
define('FTP_USER', 'ftp'); 
define( 'FTP_PASS', 'ftp' );
define('FTP_HOST', 'localhost');
define( 'DISALLOW_FILE_EDIT', true );
define( 'WP_MEMORY_LIMIT', "${WPMEMORY}" );
define( 'WP_MAX_MEMORY_LIMIT', "${WPMEMORYMAX}" );
define( 'AUTOSAVE_INTERVAL', 160 );
define( 'WP_POST_REVISIONS', 1 );
define( 'WP_CACHE', false );
define( 'WP_CRON_LOCK_TIMEOUT', 120 );
define( 'EMPTY_TRASH_DAYS', 4 );
PHP
echo $SITEURL
wp core install --path=/var/www/wordpress --url="$SITEURL" --title="wordpress" --admin_user="$WPADMIN" --admin_password="$WPPASSWORD" --admin_email="$WPEMAIL" --allow-root
sleep 3;

IFS=';' read -ra ADDR <<< "$PLUGINS"
for i in "${ADDR[@]}"; do
	echo "$i";
    	wp plugin install $i --activate --allow-root
done
chmod 777 -R /var/www;




/etc/init.d/php5-fpm start
/usr/sbin/nginx

useradd --shell /bin/sh --create-home --password 'ftp' 'ftp'

