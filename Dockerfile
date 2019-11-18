FROM debian:buster

# UPDATE
RUN apt-get update
RUN apt-get upgrade -y

# INSTALL NGINX
RUN apt-get -y install nginx

# INSTALL MYSQL
RUN apt-get -y install mariadb-server mariadb-client

# INSTALL PHP
RUN apt-get -y install php7.3 php-mysql php-fpm php-cli php-mbstring

# INSTALL TOOLS
RUN apt-get -y install wget

# COPY CONTENT
COPY ./srcs/start.sh /var/
COPY ./srcs/mysql_setup.sql /var/
COPY ./srcs/wordpress.sql /var/
COPY ./srcs/nginx.conf /etc/nginx/sites-available/localhost
RUN ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/localhost

# SETUP MYSQL
RUN service mysql start && mysql -u root mysql < /var/mysql_setup.sql

# INSTALL PHPMYADMIN
WORKDIR /var/www/
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-english.tar.gz
RUN mkdir /var/www/html/phpmyadmin
RUN tar xzf phpMyAdmin-4.9.0.1-english.tar.gz --strip-components=1 -C /var/www/html/phpmyadmin
COPY ./srcs/config.inc.php /var/www/html/phpmyadmin/
RUN chmod 755 -R /var/www/html/phpmyadmin

# INSTALL WORDPRESS
COPY ./srcs/wordpress.tar.gz /var/www/html/
RUN cd /var/www/html/ && tar xf /var/www/html/wordpress.tar.gz
RUN chmod 755 -R /var/www/html/wordpress

# SETUP SSL
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=FR/ST=75/L=Paris/O=42/CN=sdunckel' -keyout /etc/ssl/certs/localhost.key -out /etc/ssl/certs/localhost.crt

RUN chown -R www-data:www-data /var/www/*
RUN chmod 755 -R /var/www/*

# START SERVER
CMD bash /var/start.sh

EXPOSE 80
EXPOSE 443
