FROM debian:buster

# UPDATE
RUN apt-get update -y
RUN apt-get upgrade -y

# INSTALL NGINX
RUN apt-get -y install nginx

# INSTALL MYSQL
RUN apt-get -y install mariadb-server mariadb-client

# INSTALL PHP
RUN apt-get -y install php7.3 php-mysql php-fpm php-cli

# COPY CONTENT
COPY ./srcs/start.sh /var/
COPY ./srcs/nginx.conf /etc/nginx/sites-available/default
COPY ./srcs/mysql_setup.sql /var/
COPY ./srcs/wordpress.sql /var/
RUN chown -R www-data:www-data /var/www/*
RUN chmod -R 777 /var/www/*
RUN chmod 777 -R /var/www/html

# SETUP MYSQL
RUN service mysql start && mysql -u root mysql < /var/mysql_setup.sql

# INSTALL PHPMYADMIN
WORKDIR /var/www/
RUN apt-get -y install wget
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-english.tar.gz
RUN mkdir /var/www/html/phpmyadmin
RUN tar xzf phpMyAdmin-4.9.0.1-english.tar.gz --strip-components=1 -C /var/www/html/phpmyadmin
COPY ./srcs/config.inc.php /var/www/html/phpmyadmin/

# INSTALL WORDPRESS
COPY ./srcs/wordpress.tar.gz /var/www/html/
RUN cd /var/www/html/ && tar xf /var/www/html/wordpress.tar.gz
RUN chmod 777 -R /var/www/html/wordpress

# INSTALL SSL
RUN mkdir /var/www/mkcert
WORKDIR /var/www/mkcert
RUN wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.0/mkcert-v1.4.0-linux-amd64
RUN mv mkcert-v1.4.0-linux-amd64 mkcert
RUN chmod +x mkcert
RUN ./mkcert -install
RUN ./mkcert localhost

RUN service nginx reload

# START SERVER
CMD bash /var/start.sh

EXPOSE 80
EXPOSE 443
