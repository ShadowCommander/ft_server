FROM debian:buster

# update
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install wget

# install maria-db
RUN apt-get install -y mariadb-server

# install PHP
RUN apt-get install -y php php-mysql

# install NGINX
RUN apt-get install -y nginx

RUN mkdir -p /var/www/localhost
COPY srcs/localhost /var/www/localhost
COPY srcs/localhost /etc/nginx/sites-available/localhost
RUN ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/

#RUN service mysql start
#RUN mysql -u root

RUN cd /var/www/localhost
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.1/phpMyAdmin-4.9.1-english.tar.gz
RUN mkdir /var/www/localhost/phpmyadmin
RUN tar xzf phpMyAdmin-4.9.1-english.tar.gz --strip-components=1 -C /var/www/localhost/phpmyadmin

RUN service mysql restart
RUN service nginx restart
RUN /etc/init.d/php7.3-fpm start

EXPOSE 80
