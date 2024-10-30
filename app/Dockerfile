FROM rockylinux:9.3.20231119

EXPOSE 80

RUN dnf update -y && dnf install -y epel-release procps
RUN dnf install -y nginx php-fpm mariadb-server 
RUN dnf install -y php-cli php-mysqlnd php-pdo php-curl composer

RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql


RUN sed -i 's/group = apache/group = nginx/' /etc/php-fpm.d/www.conf
RUN sed -i 's/user = apache/user = nginx/' /etc/php-fpm.d/www.conf
RUN sed -i 's/listen = .*/listen = 127.0.0.1:9000/' /etc/php-fpm.d/www.conf
RUN mkdir -p /run/php-fpm && chown -R nginx:nginx /run/php-fpm

COPY ./test.conf /etc/nginx/conf.d


RUN echo "CREATE DATABASE IF NOT EXISTS laravel_db;" > /setup.sql
#RUN echo "CREATE DATABASE IF NOT EXISTS laravel_db; CREATE USER 'laravel_user'@'%' IDENTIFIED BY '1234'; GRANT ALL PRIVILEGES ON *.* TO 'laravel_user'@'%';FLUSH PRIVILEGES;" > /setup.sql

WORKDIR /home/www/public_html
RUN composer create-project --prefer-dist laravel/laravel laravel
RUN chown -R nginx:nginx /home/www/public_html/laravel/storage
RUN chown -R nginx:nginx /home/www/public_html/laravel/bootstrap/cache
COPY ./.env /home/www/public_html/laravel

WORKDIR /home/www/public_html/laravel

CMD ["sh", "-c", "/usr/bin/mysqld_safe --datadir='/var/lib/mysql' & sleep 1 && mysql -u root < /setup.sql && php artisan migrate & php-fpm & nginx -g 'daemon off;'"]


 
#ls -l /var/lib/mysql/mysql.sock
#ls -ld /run/php-fpm
