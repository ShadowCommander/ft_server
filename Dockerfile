FROM debian:buster

# UPDATE
RUN apt-get update
RUN apt-get upgrade -y

# INSTALL NGINX
RUN apt-get -y install nginx

# INSTALL MYSQL
RUN apt-get -y install mariadb-server

# INSTALL PHP
RUN apt-get -y install php7.3 php-mysql php-fpm php-cli

# COPY CONTENT
# RUN mkdir -p /var/www/html
ADD ./srcs/start.sh /var/
ADD ./srcs/mysql_setup.sql /var/
ADD ./srcs/wordpress.sql /var/

# INSTALL PHPMYADMIN
RUN apt-get -y install wget
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-english.tar.gz
RUN mkdir /var/www/html/phpmyadmin
RUN tar xzf phpMyAdmin-4.9.0.1-english.tar.gz --strip-components=1 -C /var/www/html/phpmyadmin

ADD ./srcs/nginx.conf /etc/nginx/sites-available/default

RUN chmod 777 -R /var/www/html
RUN cd /var/www/html && echo "<?php phpinfo(); ?>" > index.php
RUN service mysql start && mysql -u root mysql < /var/mysql_setup.sql

# INSTALL WORDPRESS
COPY ./srcs/wordpress.tar.gz /var/www/html/
RUN cd /var/www/html/ && tar xf /var/www/html/wordpress.tar.gz

RUN ln -s /etc/nginx/sites-available/html /etc/nginx/sites-enabled

RUN chown -R www-data:www-data /var/www/*
RUN chmod -R 777 /var/www/*

EXPOSE 80

CMD bash /var/start.sh
