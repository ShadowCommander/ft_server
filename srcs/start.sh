chown -R www-data:www-data /home/root/www*
chmod -R 755 /home/root/www*

service mysql start
service http start

mysql -u root < /home/root/mysql_setup.sql
# mysql wordpress -u root --password= < /home/root/wordpress.sql

/etc/init.d/php7.3-fpm start
service nginx restart
