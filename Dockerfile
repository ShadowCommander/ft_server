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
COPY srcs/start.sh /home/root/
COPY srcs/index.php /home/root/www/localhost
COPY srcs/mysql_setup.sql /home/root/
COPY srcs/wordpress.sql /home/root/
COPY srcs/nginx /etc/nginx/sites-available/localhost
RUN ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled

# INSTALL PHPMYADMIN
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-english.tar.gz
RUN mkdir /home/root/www/localhost/phpmyadmin
RUN tar xzf phpMyAdmin-4.9.0.1-english.tar.gz --strip-components=1 -C /home/root/www/localhost/phpmyadmin

EXPOSE 80

CMD bash /home/root/start.sh && tail -f /dev/null
