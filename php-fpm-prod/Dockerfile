FROM php:8.0-fpm-buster

# install FR locales
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get clean; \
	apt-get update; \
	apt-get install -y locales;
RUN echo "fr_FR.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen fr_FR.UTF-8 && \
    update-locale fr_FR.UTF-8
ENV LC_ALL fr_FR.UTF-8

# Install networks utils
RUN apt-get install -y iputils-ping;

# install the PHP extensions we need
RUN apt-get update || apt-get update; # FIX the apt-get install error!
# Install required packages
RUN apt-get install -y gcc libjpeg-dev libpng-dev libc-client-dev libkrb5-dev libldap2-dev libxml2-dev libzip-dev libfreetype6-dev
# KERBEROS / IMAP
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl
# GD
RUN docker-php-ext-configure gd --with-freetype --with-jpeg

# MEMCACHED
RUN apt-get install -y libmemcached-dev;
RUN curl -L -o /tmp/memcached.tar.gz "https://github.com/php-memcached-dev/php-memcached/archive/v3.1.5.tar.gz" \
  && mkdir -p memcached \
  && tar -C memcached -zxvf /tmp/memcached.tar.gz --strip 1 \
  && ( \
    cd memcached \
    && phpize \
    && ./configure \
    && make -j$(nproc) \
    && make install \
  ) \
  && rm -r memcached \
  && rm /tmp/memcached.tar.gz \
  && docker-php-ext-enable memcached

# MSMTP
RUN apt-get install -y msmtp
COPY msmtprc /etc/msmtprc
RUN chown root:msmtp /etc/msmtprc
RUN chmod 640 /etc/msmtprc
RUN touch /var/log/msmtp.log; chmod 660 /var/log/msmtp.log

# https://github.com/mlocati/docker-php-extension-installer
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions
RUN install-php-extensions intl xdebug exif gd imap ldap pcntl soap zip opcache mysqli pdo_mysql

# NETTOYAGE
RUN set -ex; \
        apt-get remove -y gcc g++ libpng-dev libjpeg-dev libfreetype6-dev \
        && rm -rf /tmp/pear;

# Clean setup
RUN rm -rf /var/lib/apt/lists/*

# SET php.ini-production
RUN ln -s /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini;

# COPY CUSTOM CONFIGS
ADD php.ini /usr/local/etc/php/conf.d/user-php.ini
ADD logs.ini /usr/local/etc/php/conf.d/logs.ini
ADD uploads.ini /usr/local/etc/php/conf.d/uploads.ini
#ADD xdebug-8.0.ini /usr/local/etc/php/conf.d/xdebug.ini
ADD opcache.ini /usr/local/etc/php/conf.d/opcache.ini
ADD php-mail.ini /usr/local/etc/php/conf.d/php-mail.ini

RUN sed -i -e "s/listen = 127.0.0.1:9000/listen = 9000/g" /usr/local/etc/php-fpm.d/www.conf;

# START PHP-FPM
CMD ["php-fpm"]
EXPOSE 9000