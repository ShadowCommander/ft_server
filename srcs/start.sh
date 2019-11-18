service php7.3-fpm start
service nginx start
service mysql start
mysql wordpress -u root --password= < /var/wordpress.sql

while true;
	do sleep 10000;
done
