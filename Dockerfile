FROM debian:buster

# UPDATE
RUN apt-get update
RUN apt-get upgrade -y
RUN apt install -y curl
RUN apt-get -y install wget

# INSTALL MYSQL
RUN apt-get -y install mariadb-server

# INSTALL PHP
RUN apt-get -y install php-mysql php-fpm php-cli

# INSTALL NGINX
RUN apt-get -y install nginx

# COPY CONTENT
RUN mkdir -p /home/root/www/localhost
COPY srcs/nginx /etc/nginx/sites-available/localhost
COPY srcs/start.sh /home/root/
COPY srcs/mysql_setup.sql /home/root/
COPY srcs/wordpress.sql /home/root/
COPY srcs/wordpress.tar.gz /home/root/www/localhost/
RUN cd /home/root/www/localhost/ && tar xf /home/root/www/localhost/wordpress.tar.gz
RUN ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled

# INSTALL PHPMYADMIN
RUN cd /home/root/ && wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-english.tar.gz
RUN mkdir /home/root/www/localhost/phpmyadmin
RUN tar xzf /home/root/phpMyAdmin-4.9.0.1-english.tar.gz --strip-components=1 -C /home/root/www/localhost/phpmyadmin

RUN chown -R www-data:www-data /home/root/www/*
RUN chmod -R 755 /home/root/www/*

RUN service mysql start && mysql -u root < /home/root/mysql_setup.sql

EXPOSE 80

CMD bash /home/root/start.sh && tail -f /dev/null
