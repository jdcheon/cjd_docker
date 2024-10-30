FROM rockylinux/rockylinux:latest

RUN dnf update -y && dnf install -y epel-release procps
RUN dnf install -y nginx php-fpm mariadb-server 
RUN groupadd -r www-data && useradd -r -g www-data www-data
RUN mkdir -p /run/php-fpm && chown -R www-data:www-data /run/php-fpm
RUN sed -i 's/listen = .*/listen = 127.0.0.1:9000/' /etc/php-fpm.d/www.conf


#RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql
#RUN echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY ''ps ; FLUSH PRIVILEGES;" > /setup.sql

EXPOSE 80

COPY ./test.conf /etc/nginx/conf.d
#COPY ./my.cnf /etc/my.cnf


CMD ["sh", "-c", "php-fpm & mysqld_safe --datadir='/var/lib/mysql' & nginx -g 'daemon off;'"]
#CMD ["sh", "-c", "/usr/bin/mysqld_safe --datadir='/var/lib/mysql' & sleep 10 && mysql -u root < /setup.sql & php-fpm & nginx -g 'daemon off;'"]


#docker run -it --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro -d -p 8080:80 --name my_clsentos centos


#ls -l /var/lib/mysql/mysql.sock
#ls -ld /run/php-fpm
