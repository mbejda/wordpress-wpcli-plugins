FROM ubuntu:13.10
MAINTAINER Milos Bejda <mbejda@live.com>

RUN echo "deb mirror://mirrors.ubuntu.com/mirrors.txt saucy main restricted universe multiverse" > /etc/apt/sources.list;\
	echo "deb mirror://mirrors.ubuntu.com/mirrors.txt saucy-updates main restricted universe multiverse" >> /etc/apt/sources.list;\
	echo "deb mirror://mirrors.ubuntu.com/mirrors.txt saucy-backports main restricted universe multiverse" >> /etc/apt/sources.list;\
	echo "deb mirror://mirrors.ubuntu.com/mirrors.txt saucy-security main restricted universe multiverse" >> /etc/apt/sources.list

RUN apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A;\
	echo "deb http://repo.percona.com/apt saucy main" >> /etc/apt/sources.list;\
	echo "deb-src http://repo.percona.com/apt saucy main" >> /etc/apt/sources.list

RUN export DEBIAN_FRONTEND=noninteractive;\
	apt-get update;\
	apt-get -qq install percona-server-server-5.5 percona-server-client-5.5 \
	php5-fpm php5-mysqlnd php5-mcrypt php5-cli \
	nginx-full \
	build-essential \
	proftpd \
	curl openssh-server
	
ADD proftpd.conf /etc/proftpd/proftpd.conf
RUN chown root:root /etc/proftpd/proftpd.conf

RUN mkdir /var/run/sshd;\
	echo "root:root"|chpasswd;\
	sed -i 's|session.*required.*pam_loginuid.so|session optional pam_loginuid.so|' /etc/pam.d/sshd;\
	echo LANG="en_US.UTF-8" > /etc/default/locale

RUN curl -L https://raw.github.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > wp-cli.phar;\
	chmod +x wp-cli.phar;\
	mv wp-cli.phar /bin/wp

RUN sed -i 's|listen.*=.*|listen=127.0.0.1:9000|' /etc/php5/fpm/pool.d/www.conf;\
	sed -i 's|;cgi.fix_pathinfo.*=.*|cgi.fix_pathinfo=0|' /etc/php5/fpm/php.ini;\
	sed -i 's|;date.timezone.*=.*|date.timezone=Europe/Sofia|' /etc/php5/fpm/php.ini

RUN mkdir -p /var/www/wordpress;\
	chown -R www-data:www-data /var/www;\
	chmod -R 0755 /var/www
RUN /etc/init.d/proftpd start
RUN NGINXCONFFILE=/etc/nginx/nginx.conf;\
	echo "daemon off;" | cat - $NGINXCONFFILE > $NGINXCONFFILE.tmp;\
	mv $NGINXCONFFILE.tmp $NGINXCONFFILE

ADD nginx/default /etc/nginx/sites-available/default
ADD wordpress /var/www/wordpress



ENV SITEURL="127.0.0.1"
ENV PLUGINS=""
ENV WPMEMORY="9M"
ENV WPMEMORYMAX="10M"
ENV WPADMIN="admin"
ENV WPPASSWORD="password"
ENV WPEMAIL="admin@admin.com"

ADD shell/install.sh /

EXPOSE 80 22 20 21

CMD ["bash", "/install.sh"]